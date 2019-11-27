Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702D6C432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 20:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5336020661
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 20:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfK0UNO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 15:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfK0UNO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 15:13:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7864C20661;
        Wed, 27 Nov 2019 20:13:12 +0000 (UTC)
Date:   Wed, 27 Nov 2019 15:13:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] kernel-shark: When running as Root save all
 config settings in /root/
Message-ID: <20191127151310.680478f1@gandalf.local.home>
In-Reply-To: <20191023122145.14314-3-y.karadz@gmail.com>
References: <20191023122145.14314-1-y.karadz@gmail.com>
        <20191023122145.14314-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Oct 2019 15:21:45 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> If KernelShark is running with Root privileges, do not save the settings
> in the standard location. Otherwise the configuration files will be owned
> by Root and later the normal user will have no access to those files.
> 
> The patch seems to do the right thing in all cases that I tested, however
> there is definitely something that I do not understand. QDir::homePath()
> always returns the path to the home of the normal user, even if I build
> and run kernelshark as root (sudo -s).
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 3402764..bd6c338 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -69,7 +69,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>    _contentsAction("Contents", this),
>    _bugReportAction("Report a bug", this),
>    _deselectShortcut(this),
> -  _settings("kernelshark.org", "Kernel Shark") // organization , application
> +  _settings(_getCacheDir() + "/setting.ini", QSettings::IniFormat)
>  {
>  	setWindowTitle("Kernel Shark");
>  	_createActions();
> @@ -431,6 +431,9 @@ QString KsMainWindow::_getCacheDir()
>  		dir = QStandardPaths::writableLocation(appCachePath);
>  		dir += "/kernelshark";
>  
> +		if (geteuid() == 0)
> +			dir.replace(QDir::homePath(), "/root");
> +
>  		if (!QDir(dir).exists())
>  			lamMakePath(false);
>  	}

I'll pull this patch in, but this assumes that root is always at /root.
I've had machines where that was not the case. I wonder if we should
add something like this on top of this patch. Not this change directly,
(because this is me just writing C with at C++ compiler ;-), but
something that is more the Qt way...

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index bd6c338f..56cf9b9b 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -31,6 +31,43 @@
 #include "KsCaptureDialog.hpp"
 #include "KsAdvFilteringDialog.hpp"
 
+static QString find_root_home(void)
+{
+	FILE *fp = fopen("/etc/passwd", "r");
+	char *buf;
+	char *sav;
+	char *id;
+	size_t n;
+
+	if (!fp)
+		return QString("/root");
+
+	n = 0;
+	while (getline(&buf, &n, fp) != -1) {
+		/* user */
+		strtok_r(buf, ":", &sav);
+		/* type */
+		strtok_r(NULL, ":", &sav);
+		/* pid */
+		id = strtok_r(NULL, ":", &sav);
+		if (atoi(id) != 0) {
+			n = 0;
+			free(buf);
+			continue;
+		}
+		/* gid */
+		strtok_r(NULL, ":", &sav);
+		/* group */
+		strtok_r(NULL, ":", &sav);
+		/* home */
+		QString ret = QString(strtok_r(NULL, ":", &sav));
+		free(buf);
+		return ret;
+	}
+	free(buf);
+	return QString("/root");
+}
+
 /** Create KernelShark Main window. */
 KsMainWindow::KsMainWindow(QWidget *parent)
 : QMainWindow(parent),
@@ -432,7 +469,8 @@ QString KsMainWindow::_getCacheDir()
 		dir += "/kernelshark";
 
 		if (geteuid() == 0)
-			dir.replace(QDir::homePath(), "/root");
+			dir.replace(QDir::homePath(),
+				    find_root_home().toStdString().c_str());
 
 		if (!QDir(dir).exists())
 			lamMakePath(false);

This reads the /etc/passwd file and searches for the pid of 0, and
returns the home path for that user. On any error it just
quietly defaults back to "/root".

-- Steve
