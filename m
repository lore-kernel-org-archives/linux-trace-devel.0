Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43201C282CE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2300020656
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfDVOzg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:55:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53166 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbfDVOzf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 10:55:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id a184so14726788wma.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 07:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qiWlGJhhYrmqLjdL0koxlW+uR3/5Fcs1GSzGZF7p5j4=;
        b=gp2Rz78m5GokQ9l9487UqC8a0X50xWglF63qwyXBuLwNhlLLFiVcQhwzy66UdmRlac
         e7sm7XMQUlopt7/qnZQ2ETMgsvwzDlOD78gpY7N/vQtEivej+xnBQPggmeA5NOzvPwgQ
         K6zMco/fZCBd5GiVQUvuTGng+3mcIyLuODX6NaXrNXr3usSZzowH3cp62kvd1tjmfKVm
         aR200k4WCZXkpDHvR70Awkirw4vTy3pOpj+MTQFFE9IcpRNbGj7OPx9e9pDc5GeU+dUC
         Qvd0mShU3zcQvbeKKakWFZWL7q0TXryG0ma9oJX7ZVbc8xONj4uJbT6lrobbiWrNJMEV
         OJKQ==
X-Gm-Message-State: APjAAAWI/lLEI4t3hOyrvPMDsLkTNLmiAOE8fEKi69iFOQUNNBT2YzRi
        O2307YOR1covBuIZ5oIR7Q==
X-Google-Smtp-Source: APXvYqxOogkxNH+W7iwFFQk/Ky2PLLFDCvtkuoN0ASwf1i7ZWyiinvGQtqDUbp0zPzN2uWIPReWhbw==
X-Received: by 2002:a1c:40c3:: with SMTP id n186mr12883258wma.3.1555944934148;
        Mon, 22 Apr 2019 07:55:34 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f128sm17321087wme.28.2019.04.22.07.55.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 07:55:33 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 09/12] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Mon, 22 Apr 2019 17:55:16 +0300
Message-Id: <20190422145519.16146-10-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422145519.16146-1-kaslevs@vmware.com>
References: <20190422145519.16146-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When no number of guest CPUs is provided with the -c flag to `trace-cmd
setup-guest`, try to autodetect it using virsh for libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 21 +++++++++++++++++++++
 tracecmd/trace-usage.c       |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index a6f58dc..a55a37d 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -93,6 +93,24 @@ static int make_guest_fifos(const char *guest, int nr_cpus, mode_t mode)
 	return ret;
 }
 
+static int get_guest_cpu_count(const char *guest)
+{
+	const char *cmd_fmt = "virsh vcpucount --maximum '%s' 2>/dev/null";
+	int nr_cpus = -1;
+	char cmd[1024];
+	FILE *f;
+
+	snprintf(cmd, sizeof(cmd), cmd_fmt, guest);
+	f = popen(cmd, "r");
+	if (!f)
+		return -errno;
+
+	fscanf(f, "%d", &nr_cpus);
+	pclose(f);
+
+	return nr_cpus;
+}
+
 static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gid)
 {
 	gid_t save_egid;
@@ -171,6 +189,9 @@ void trace_setup_guest(int argc, char **argv)
 
 	guest = argv[optind+1];
 
+	if (nr_cpus <= 0)
+		nr_cpus = get_guest_cpu_count(guest);
+
 	if (nr_cpus <= 0)
 		pdie("invalid number of cpus for guest %s", guest);
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index d0b84f9..2e5be6c 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -250,7 +250,7 @@ static struct usage_help usage_help[] = {
 	{
 		"setup-guest",
 		"create FIFOs for tracing guest VMs",
-		" %s setup-guest -c cpus[-p perm][-g group] guest\n"
+		" %s setup-guest [-c cpus][-p perm][-g group] guest\n"
 		"          -c number of guest virtual CPUs\n"
 		"          -p FIFOs permissions (default: 0660)\n"
 		"          -g FIFOs group owner\n"
-- 
2.19.1

