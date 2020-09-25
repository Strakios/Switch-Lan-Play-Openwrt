package main

import (
	"context"
	"os"
	"path"

	"github.com/cavaliercoder/grab"
	"github.com/google/go-github/v32/github"
	"github.com/mholt/archiver/v3"
	"github.com/op/go-logging"
	"golang.org/x/oauth2"
)

var log = logging.MustGetLogger("generator")

func main() {
	// init
	var targetDir string = "website"

	os.RemoveAll(targetDir)
	os.MkdirAll(targetDir, os.ModePerm)

	log.Info("Starting...")

	//auth
	githubToken, _ := os.LookupEnv("GITHUB_TOKEN")
	ctx := context.Background()
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: githubToken},
	)
	tc := oauth2.NewClient(ctx, ts)
	client := github.NewClient(tc)

	//start
	workflows, _, err := client.Actions.ListWorkflowRunsByID((context.Background()), "htynkn", "openwrt-switch-lan-play",
		1659879,
		&github.ListWorkflowRunsOptions{
			Status: "completed",
			ListOptions: github.ListOptions{
				Page: 1, PerPage: 1,
			},
		})

	if err != nil {
		log.Error("fail to call github api")
		return
	}

	var targetWorkflowID int64 = 0

	for _, value := range workflows.WorkflowRuns {
		log.Info("get workflowRun: ", *value.ID, *value.HeadSHA)
		if *value.ID > 0 {
			targetWorkflowID = *value.ID
			log.Info("use runId:", targetWorkflowID)
			break
		}
	}

	artifacts, _, err := client.Actions.ListWorkflowRunArtifacts(context.Background(), "htynkn", "openwrt-switch-lan-play",
		targetWorkflowID,
		&github.ListOptions{
			Page: 1, PerPage: 10,
		},
	)

	if err != nil {
		log.Error("fail to call github api")
		return
	}

	log.Info("artifacts total:", *artifacts.TotalCount)
	for _, value := range artifacts.Artifacts {
		log.Info("artifact: ", *value.Name, *value.ArchiveDownloadURL)

		url, _, err := client.Actions.DownloadArtifact(context.Background(), "htynkn", "openwrt-switch-lan-play", *value.ID, true)

		if err != nil {
			log.Error("fail to call github api", err)
			return
		}

		log.Info("download url:", url.String())
		resp, err := grab.Get(targetDir, url.String())

		if err != nil {
			log.Fatal("fail to download file", err)
		}

		log.Info("saved file: ", resp.Filename)
		err = archiver.Unarchive(resp.Filename, targetDir)

		if err != nil {
			log.Fatal("fail to unzip file", err)
		}

		archiver.Unarchive(path.Join(targetDir, "target.zip"), targetDir)

		os.Remove(path.Join(targetDir, "target.zip"))
		os.Remove(resp.Filename)
	}
}
