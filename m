Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02617C4CEC4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E16218AF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390275AbfISVZo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390567AbfISVZo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 17:25:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C92A21D79;
        Thu, 19 Sep 2019 21:25:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iB3vq-0008Ui-Ak; Thu, 19 Sep 2019 17:25:42 -0400
Message-Id: <20190919212542.216189588@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Sep 2019 17:23:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 5/6] tools/lib/traceevent: Man pages for tep plugins APIs
References: <20190919212335.400961206@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:
  tep_load_plugins(),
  tep_unload_plugin()

Link: http://lore.kernel.org/linux-trace-devel/20190903133434.30417-1-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../Documentation/libtraceevent-plugins.txt   | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
new file mode 100644
index 000000000000..596032ade31f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_load_plugins, tep_unload_plugins - Load / unload traceevent plugins.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
+void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+The _tep_load_plugins()_ function loads all plugins, located in the plugin
+directories. The _tep_ argument is trace event parser context.
+The plugin directories are :
+[verse]
+--
+	- System's plugin directory, defined at the library compile time. It
+	  depends on the library installation prefix and usually is
+	  _(install_preffix)/lib/traceevent/plugins_
+	- Directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
+	- User's plugin directory, located at _~/.local/lib/traceevent/plugins_
+--
+Loading of plugins can be controlled by the _tep_flags_, using the
+_tep_set_flag()_ API:
+[verse]
+--
+	_TEP_DISABLE_SYS_PLUGINS_	- do not load plugins, located in
+					the system's plugin directory.
+	_TEP_DISABLE_PLUGINS_		- do not load any plugins.
+--
+The _tep_set_flag()_ API needs to be called before _tep_load_plugins()_, if
+loading of all plugins is not the desired case.
+
+The _tep_unload_plugins()_ function unloads the plugins, previously loaded by
+_tep_load_plugins()_. The _tep_ argument is trace event parser context. The
+_plugin_list_ is the list of loaded plugins, returned by
+the _tep_load_plugins()_ function.
+
+RETURN VALUE
+------------
+The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
+or NULL in case no plugins are loaded.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_plugin_list *plugins = tep_load_plugins(tep);
+if (plugins == NULL) {
+	/* no plugins are loaded */
+}
+...
+tep_unload_plugins(plugins, tep);
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_set_flag(3)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1


