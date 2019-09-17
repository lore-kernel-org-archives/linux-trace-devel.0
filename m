Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E7AC4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8098B214AF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfIQNQC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:16:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33846 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbfIQNQC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:16:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so3165713wrx.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QvCgiuARbWoOTArO6fMu4q/VDAhGI5uaemx6BDhv4sY=;
        b=Stq3FKzIIa1kwAXI3gokVwzUUl52WgGDnqAYYKyFJFIoJenjF0fxsUUS/xHOQOspN4
         yY7dpHABH15hEYSbIE2BZRh9qOhwX2pejw0oSUsCY8uSuseFbmR+mabySjMINXvu0BOd
         swUrpfZ8jaF5yXJAJS5Hf8LVITbtdPt+hzJGAs8k2Axt3RFNqnmhE2RoS24F7lTRnR3R
         aauSNsCohX6bXu5rfXRqpM43+rqregUFZ8Zm0ZFw0InrACxyToGb1o6hXepK2tWptreC
         CNKrFTEUuZHhH137xwISSwlo2Fec33pmrWxN9JzNfL8L+3zB/cqEnA04YB2Dda2Ou2yQ
         sQzA==
X-Gm-Message-State: APjAAAVvi5dYmvgszH1/Zb2toiQNPEK6bFEORUyAbJFRXbl4me/VRDuv
        FgP4I3euWEUgC7AnaHTIPEwVkGmZYw==
X-Google-Smtp-Source: APXvYqyPnK7/Nx2GsS1RtM8qXaz6VaLJBOeeEoxG+2Tl3T0A2rIqn0GH8ilPXQOFw3Iot1kekyTipA==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr3182167wrr.334.1568726159867;
        Tue, 17 Sep 2019 06:15:59 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:59 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 13/13] trace-cmd: Add support for tracing VMware Workstation VMs by name
Date:   Tue, 17 Sep 2019 16:15:38 +0300
Message-Id: <20190917131538.31926-14-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190917131538.31926-1-kaslevs@vmware.com>
References: <20190917131538.31926-1-kaslevs@vmware.com>
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
 tracecmd/trace-record.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3aab6cb..41a95ea 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2894,6 +2894,77 @@ next:
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
+			if (!*name)
+				die("allocating guest name");
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
@@ -2915,6 +2986,7 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 		*cid = atoi(guest);
 
 	read_qemu_guests();
+	read_vmw_guests();
 	for (i = 0; i < guests_len; i++) {
 		if ((*cid > 0 && *cid == guests[i].cid) ||
 		    strcmp(guest, guests[i].name) == 0) {
-- 
2.20.1

