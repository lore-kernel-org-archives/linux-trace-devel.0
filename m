Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E981624E8
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744376545; cv=none; b=c+6XsedJUfCdQVFt5Wzy7GZQ/LofQb5BBo8NHNqWE2liX9nr3qJWMD9afY8QYup6WEYW/jzO82QsPJ/1yCktRW54IsP/Myvz8/jRGklmi2M4WZ/FV+DCR+zBHPH+yT4XS6Zr8lDGlUuKpQVzC3B4mn4wIPFwMrB/1338LkQ22Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744376545; c=relaxed/simple;
	bh=XQxtJY8jwwZtenVItXalH6lI7QBaG5cwhBlUzX4iMr4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Q18VrM9nljYyp/SxOtBODXgpw8NLDEakbyAKBf0vl7f7TJ+fYyeWmDPqVPHK6I5W+HSqiD2VtSvBNFtepyFu1p1iYYfRVGIQRp+ODidORLAOnN7QT4lJuU2+zd5ujaVsWWnL8lRPtRBDLJ+4/TrVapnn8eCwYQHpVOvKxIzZ2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B07C4CEE7
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 13:02:25 +0000 (UTC)
Date: Fri, 11 Apr 2025 09:03:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Install completion script in
 /usr/share/bash-completion/completions
Message-ID: <20250411090349.09984c9b@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The meson install installs the bash completion in
/usr/share/bash-completion/completions where as the normal "make install"
places the script into /etc/bash_completions.d/. The former is actually
where it should be installed.

Change the make install to place the bash completion script into
/usr/share/bash-completion/completions like the meson install does.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index e044a0f0..5c0f1a33 100644
--- a/Makefile
+++ b/Makefile
@@ -70,6 +70,8 @@ bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
+completion_dir = $(prefix)/share/bash-completion/completions
+completion_dir_SQ = '$(subst ','\'',$(completion_dir))'
 html_install_SQ = '$(subst ','\'',$(html_install))'
 img_install_SQ = '$(subst ','\'',$(img_install))'
 libdir = $(prefix)/$(libdir_relative)
@@ -79,9 +81,6 @@ includedir_SQ = '$(subst ','\'',$(includedir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
 
-etcdir ?= /etc
-etcdir_SQ = '$(subst ','\'',$(etcdir))'
-
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ libdir libdir_SQ includedir_SQ
 export DESTDIR DESTDIR_SQ
@@ -115,8 +114,6 @@ HELP_DIR = -DHELP_DIR=$(html_install)
 HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 #' emacs highlighting gets confused by the above escaped quote.
 
-BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
-
 export PLUGIN_DIR_TRACECMD
 export PYTHON_DIR
 export PYTHON_DIR_SQ
@@ -500,7 +497,7 @@ install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
 
 install_bash_completion: force
-	$(Q)$(call do_install_data,$(src)/tracecmd/trace-cmd.bash,$(BASH_COMPLETE_DIR))
+	$(Q)$(call do_install_data,$(src)/tracecmd/trace-cmd.bash,$(completion_dir))
 
 install_cmd: all_cmd install_plugins install_python install_bash_completion
 	$(Q)$(call do_install,$(obj)/tracecmd/trace-cmd,$(bindir_SQ))
-- 
2.47.2

