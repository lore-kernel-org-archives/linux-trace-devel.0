Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5F1C4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B990721473
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfDBNqD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:46:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35562 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731935AbfDBNp5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:45:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id w1so16785159wrp.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFSfYbrnzTILtWrs9yoh6xKLu0arQMKC+MY9kH1Nax0=;
        b=LRnmf83WrZto/Vh2UtxKsLlkg0Vf5W+iKNSqka8Gu6t3t7mWJPqEM3NSlUehWD0XL9
         yLxQQWV4WvGyH0iqm5EpVvjc0iqGQoNHOIUjw2D1UGLc+9Y6yEiWYstLlZ9Btc8mHR3Q
         e8UeUXJi5a4tg8MdxRi++SdrfWq7beA88MQ0gHJ9a0wL/0RYKLs9/30C5c2HaOXGj3Kb
         Xyc490DEeIE9DgnjsqbkTDmqL+1RYiokh/PqpSyjtVXRUUdGrK+/3FSjJvb1u8sdtnZ8
         NbHXcqJVIpQvKp/cW4a1nQrfa4uPHcN48e/1EIl3fx1DZDRBfTCSxX3M9xUPn/QpJu1q
         nZgQ==
X-Gm-Message-State: APjAAAV3zVO4ZiWsPwdPY6U5j7+Q5/UhchnWdQpUfMFiHpUINFTUJTIh
        wOEkJqqCCsMTGKjhU+EFyHO/ktI0kQ==
X-Google-Smtp-Source: APXvYqxM1hARpxuFkkulY6atApScWuW+YiE785siY3KR1riGFO7orzB06vvGwmwetov4vP7mGy3j2A==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr38083379wrw.174.1554212755505;
        Tue, 02 Apr 2019 06:45:55 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 17sm1765336wmk.39.2019.04.02.06.45.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:45:54 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v9 09/11] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Tue,  2 Apr 2019 16:45:38 +0300
Message-Id: <20190402134540.32321-10-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134540.32321-1-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
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
index 7a8002f..9a13d93 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -249,7 +249,7 @@ static struct usage_help usage_help[] = {
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

