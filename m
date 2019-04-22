Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FA2C282E5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7203D20874
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfDVOzj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:55:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39975 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVOzj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 10:55:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so16088670wre.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 07:55:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hdv6jz/mIoNy//gVs8L0JQG+J7rh7BQdNRapLgBsTNE=;
        b=cD3DZcHmTxt3tTMrii0G7RG/4+eozwD5sFFYU9O9VspJcxd59iD7Z8/j4XHfcxDbBY
         zA04moSsxZrbkDgcrvmgatr4rhPJFyFK2uQGe33iazi21DuZzc2p3W8oQPmNk4Ntw1dJ
         x8jrtBhEbWvEFmr7xqigsHEpcRhmYZrWCmIsetbzYLnAY6QGLJq8NMrG9Oj++aHEffLg
         cGu4hVsEIhq1YcKcjObjYSCWkLlMjPWORPI+XPTvdJypTJyuzTHVHtfycKBGrZcshT6Z
         ZPkoiJN56hSQD/n6HRBD4GdBc+MXZv3iAXNcNQMzdwWC3lZeS5HrFHdJLUI8DIYIgY9R
         Yq0A==
X-Gm-Message-State: APjAAAXIFyUmjmDAGG2AlPEJoZxeEXYXmPZ6h65D7Mw+krSO+ry+0wVS
        o7NXPG5mqhgPgFbK+WG7JQ==
X-Google-Smtp-Source: APXvYqxxxn9brnngZUR89jOYH2hbieTXjS/vCJJAt294p5b4YEgd+dLKuTcEIFnfMatRQeMVqNK31A==
X-Received: by 2002:adf:e892:: with SMTP id d18mr1049862wrm.271.1555944937090;
        Mon, 22 Apr 2019 07:55:37 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f128sm17321087wme.28.2019.04.22.07.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 07:55:36 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 12/12] trace-cmd: Add support for tracing VMware Workstation VMs by name
Date:   Mon, 22 Apr 2019 17:55:19 +0300
Message-Id: <20190422145519.16146-13-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422145519.16146-1-kaslevs@vmware.com>
References: <20190422145519.16146-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Read display name and CID of running VMware Workstation guests on startup so
that users can refer to them by name when recording.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 70 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c2c58aa..29f5784 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2886,6 +2886,75 @@ next:
 	closedir(dir);
 }
 
+static int load_vmw_guest(const char *vm, char **name, int *cid)
+{
+	size_t line_len = 0;
+	char *line = NULL;
+	char *p;
+	FILE *f;
+
+	f = fopen(vm, "r");
+	if (!f)
+		return -errno;
+
+	*cid = -1;
+	*name = NULL;
+	while (getline(&line, &line_len, f) != -1) {
+		if (strncmp(line, "displayName = ", 14) == 0) {
+			p = strrchr(line, '"');
+			if (p)
+				*p = '\0';
+			*name = strdup(line + 15);
+		} else if (strncmp(line, "vmci0.id = ", 11) == 0) {
+			p = strrchr(line, '"');
+			if (p)
+				*p = '\0';
+			*cid = atoi(line + 12);
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return 0;
+}
+
+static void read_vmw_guests(void)
+{
+	static bool initialized;
+	size_t line_len = 0;
+	char *line = NULL;
+	ssize_t ret;
+	FILE *f;
+
+	if (initialized)
+		return;
+
+	initialized = true;
+
+	f = popen("vmrun list", "r");
+	if (!f)
+		return;
+
+	/* Ignore the first line */
+	ret = getline(&line, &line_len, f);
+	while ((ret = getline(&line, &line_len, f)) != -1) {
+		struct guest guest = {};
+
+		if (ret > 0 && line[ret-1] == '\n')
+			line[ret-1] = '\0';
+		if (load_vmw_guest(line, &guest.name, &guest.cid))
+			continue;
+
+		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
+		if (!guests)
+			die("Can not allocate guest buffer");
+		guests[guests_len++] = guest;
+	}
+
+	free(line);
+	pclose(f);
+}
+
 static char *parse_guest_name(char *guest, int *cid, int *port)
 {
 	size_t i;
@@ -2907,6 +2976,7 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 		*cid = atoi(guest);
 
 	read_qemu_guests();
+	read_vmw_guests();
 	for (i = 0; i < guests_len; i++) {
 		if ((*cid > 0 && *cid == guests[i].cid) ||
 		    strcmp(guest, guests[i].name) == 0) {
-- 
2.19.1

