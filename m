Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3896C10F0B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1F1C20856
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbfDBNnB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:43:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40018 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731879AbfDBNnA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:43:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so16701526wre.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wGyYqYTaWp7jSzh02FXSmxuS07TS71n2orhCthe5OBo=;
        b=b8iYLivQW/3GZ2COWHJ7z82Fymj1qj27+DT+b94gbqzIZ+SmBZIJUTJYTXFQ0E0HSk
         DKSRkfqcBlroXK9PQ4X+S1ed77DcrraXXum7jeMnRYXIRjFNzdRO+D+yfCLOxCnnWDS5
         9OrhD980iEPObIC7ePgIB6b35c36htbsC3yQps40yT8AwryoNYQL8koxK6OWtuuM6P4J
         87JK5j9CRAfXYYWtDZ+9pAKFXMh9WDkTiw3+1A9vpfXlNKK6zx4CNJKJLsaHidvwIf6S
         dZESxWfM0i/TIBg3TntA14meM2BsW99VkoiwMGFYTGllRL/QGXAIKoqrN99PrF8Yqxu4
         Uxhw==
X-Gm-Message-State: APjAAAVfyLFV1w+n7nPgCeOOSPHOv1VqbY9GELMXaJS4dIB8Y0tHIiLZ
        ZYig4Wsl4SeFMkZmisHA9jbcDTd+vw==
X-Google-Smtp-Source: APXvYqze7+EurR6bHbP3zNjLkG15g+L+tE2w+DPFo810qrStk/lyOpArTDFg+MPslloq9F4fysSMvQ==
X-Received: by 2002:a5d:6a4f:: with SMTP id t15mr45375064wrw.156.1554212578538;
        Tue, 02 Apr 2019 06:42:58 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:57 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Tue,  2 Apr 2019 16:42:26 +0300
Message-Id: <20190402134230.30988-21-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
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
index 5e66551..15ec637 100644
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

