Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19144C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E175E20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OJ+adphZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfFROpR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35079 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbfFROpR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so3590697wml.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4s1bcMdpvWlQEOr9Gk/+jJmGEYEZ+q85dpfudC7SBjQ=;
        b=OJ+adphZrtg8z79PwTqhTXDDVrXhpdathz3AqjRcodz7x77FLc0ncetLYF37SNgs3m
         aU7R0aqPW4ZPG3oS1Nbf66Sscl1Bu7h2a8tLZ02Zr8WQiElFw1GuBR+79c/LbRigciP5
         582wKdtoAsWN5/FupxHBIuLWKwmxtkabWPq8jI+7HgXL/01NZNDbp5LkPeDVoeTRaKIO
         nP3z6RYbYzZmj5M/SxysvEfl7lO6440LLdps+MUDugQ7RCP+v2laWGET2DEV8mXmLtF2
         YWn/0Q28INrZ1mRDKAAxI5YSkBezWT+F+kOOOBpaN0nvYZej1QaaZKWlbot5sEW66n3F
         HbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4s1bcMdpvWlQEOr9Gk/+jJmGEYEZ+q85dpfudC7SBjQ=;
        b=jlAeSG+6mo20/9v6n88meu4RRqz60r+dNJqYfONp8aO90uvCaS4gBnCi9ljPAdd611
         86QRSMRZBDq9QhGukGieHHQSRySljZoZYlYdylBido8NHMhgQ6VfCJn5FARvmV6gkkxG
         tXgAp5jgsoz3QIYCpx2qCKvXEDN1Ax45riRS1V5AjKxyYHTm8p0erqMF5ON/hdEhNdG5
         WvQ49G+zSDTcpshHbfbNQ/ZaoWplfpKNBjTA7SqT7E3/eRpgaQj70nyTc9PHdHrYueqc
         KF8ZNKd+DhShyGra0p1rCgrxg5I4ILLburjQLCNkT0KWHuWyFCZ0fur9TTsC87/QO3k/
         FGrw==
X-Gm-Message-State: APjAAAU6ZbJCV7m1L0FBa1/zq1rKA3e/KLyV+3O3XSWhz6DTiMpYQ6eD
        mM0l3m7zWe/tge9w7TsCmw==
X-Google-Smtp-Source: APXvYqyd4iDfm5qSrH6rMkecz9uFJw1uFzwjaw4HQ5V8LTz9ABlbzVwECNbhTzWoVb3GJvuJjap5wQ==
X-Received: by 2002:a1c:9cd1:: with SMTP id f200mr3865751wme.157.1560869115211;
        Tue, 18 Jun 2019 07:45:15 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:14 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 13/13] trace-cmd: Add support for tracing VMware Workstation VMs by name
Date:   Tue, 18 Jun 2019 17:44:55 +0300
Message-Id: <20190618144455.3954-14-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Read display name and CID of running VMware Workstation guests on startup so
that users can refer to them by name when recording.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 70 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 89e2c52..b242f34 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2892,6 +2892,75 @@ next:
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
@@ -2913,6 +2982,7 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 		*cid = atoi(guest);
 
 	read_qemu_guests();
+	read_vmw_guests();
 	for (i = 0; i < guests_len; i++) {
 		if ((*cid > 0 && *cid == guests[i].cid) ||
 		    strcmp(guest, guests[i].name) == 0) {
-- 
2.20.1

