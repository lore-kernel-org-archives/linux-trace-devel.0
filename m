Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D2FC31E5E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0FEB20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtkwFDuT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfFROkT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39142 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfFROkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so14288413wrt.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wRhE2USNkyWhVFESY7aZ28+NJrvuNFHOu+uZjWk5Vnk=;
        b=XtkwFDuTUMWtqwmghV0NTwRq/S0yPkyRTvaRkigxGCE7jaKvO/NDhY6rV3RUTBGxEO
         xFN/FtBOTS4ljbcORLWaZmc/maD+23rTNiYS97XFTgF0LHJR5AFvl6Tf5S1Zmj9IEIAJ
         RfXCLw15+StA2r5P7G1SDbTeeVL30PwWTBIp/FXfpi9pnc01JaIT6/Ym1Lh1pnhxx6Bw
         XXrHggehv9EW3+NIK8Az8/thlMKRvOwtfC5dQ7MnnS3lo0Sb74JrmKrghur6YmAumAkE
         dXhdT4L0JosLCLL3gqEzK4L5/7wSW0UBNP4JXAdzoAPn+eryEkTExm9TsawQKRTajav5
         NXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wRhE2USNkyWhVFESY7aZ28+NJrvuNFHOu+uZjWk5Vnk=;
        b=k8c3YC7j8dgUo7aYvZ88etGAWE5UYh704gEfzbEhJaBiAJwwxX3DY3F8GDNg4RfGbd
         7tBfcAn6msF4z5F/pSiEGIa59SsguTBVR+GD2tlk/5kK+1W+gl1wqi68vsm0X1HIQrLe
         gPXssnJcAPnrvHmea6GPC2rO0DSlCwVF5Twtl7ChbF7cjgacRsUo9tNsAVeWKClUOIKa
         r6n1s8xFtXhlRclNa1y1UqF1QrzwqkhGVDG3BYal3alB/Kv2at5VreTEbEuIhFkon6zL
         fvo56uT5TMu+Xde0dAOwhuv6y1Er6YE6IFACzvZuha3qvWzdfjFs8t1U9UBHh6XnsvQS
         r+Lg==
X-Gm-Message-State: APjAAAWYHN4STrtPdlGUVrNSgRF0F8S9G+33dZH1FD34cqembJTupYgZ
        D/kN7ckUxQ2p5tmy72jM1aAGyac=
X-Google-Smtp-Source: APXvYqxbXLATIfiGcFwTFlGevXd30wx7WAKqa0ti9gfhsEzgOea/48iM3oMg2oMFFHXvO8EHmFv/sA==
X-Received: by 2002:a5d:4752:: with SMTP id o18mr12496507wrs.74.1560868817624;
        Tue, 18 Jun 2019 07:40:17 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:16 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Tue, 18 Jun 2019 17:39:55 +0300
Message-Id: <20190618143958.2865-11-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
References: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

When no number of guest CPUs is provided with the -c flag to `trace-cmd
setup-guest`, try to autodetect it using virsh for libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
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
index 0d1b58e..a2a520c 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -251,7 +251,7 @@ static struct usage_help usage_help[] = {
 	{
 		"setup-guest",
 		"create FIFOs for tracing guest VMs",
-		" %s setup-guest -c cpus[-p perm][-g group] guest\n"
+		" %s setup-guest [-c cpus][-p perm][-g group] guest\n"
 		"          -c number of guest virtual CPUs\n"
 		"          -p FIFOs permissions (default: 0660)\n"
 		"          -g FIFOs group owner\n"
-- 
2.20.1

