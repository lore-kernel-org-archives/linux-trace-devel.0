Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925F3C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6717323711
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZG5l277V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfICNek (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42545 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICNej (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so17506851wrq.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 06:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKhID5mvCieXe8QMhdLW08oKT7hoUcTpFJcmW9/ad1w=;
        b=ZG5l277VPMfX1F8UCZ9E3xDw04wKyIsSuo2PEvXwDTBUo1xofcu08DQYK7L8izxe/v
         NhHPt4dI9/cRJ9zDOGce/BpLUY350OjKPpTEQhHloPoZPAzfBcEYjrafmEQkZ+/QHQ3u
         ozq6jxXVt2/PgSvjcfMA3gwdubEOJk+NJtIx5mfDbaMBHnKmEG0Xh2RhVOlrJQ2nLNV2
         zMqA9aydfYgQshLC+qJReGs0+9/DWIShIiYGIgD2A/cIsj6YcT/3TljvV7h/GdVgBQQv
         BixrPoXR6Dx7viZFaFBT0jo+gKUTEBWa7ti2gczR8qFDuwdHdzXi5AAadC+bvLLXAByl
         Dirg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKhID5mvCieXe8QMhdLW08oKT7hoUcTpFJcmW9/ad1w=;
        b=C+Qi5okc6LtworHYeuxMv10JHzX+3zh/CbG8P7cJTCUayYnMxk2mUTfEWV+s/1cbt1
         cuLWvEHZ5TVKmLJPQ2eVC9hHlouV25UD2ViIK/XNT928d0fVifIC+Jt3iwZDNYc2j8p9
         g81SP0iVMXxDhZkMwsPh4V8KAsmQ6cm4NUkG1Ntlbl7fBJHQBv097Ss0CZpR/MbXr3h7
         W27Xm2LWf9n6SU21vZgNx2C3QqmvUpUHIloSjW+PV8bNBvXG1kppBWO9aESx2phe0gZx
         GajNom46F9x/nyCGthoeyNGc3/rkWB/woNew7daj8hfxDgGnRkWDaOE66cp1nrpe8yVx
         iasg==
X-Gm-Message-State: APjAAAU/A/rPjaSKBSwf7TN/H4GE8i45K+FW9tJdgZBgUBabyPz8vVmZ
        Mu2IGHBXqXU1WHstPovF6Z2zguee
X-Google-Smtp-Source: APXvYqyo5T+TNTTENa71EdyLfi/fAvuprIYy9mzNhvtY11um8ptEDCwUr3fqjelkDZ723uqHmTRaxA==
X-Received: by 2002:adf:e3ce:: with SMTP id k14mr40343977wrm.303.1567517677905;
        Tue, 03 Sep 2019 06:34:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g201sm21167052wmg.34.2019.09.03.06.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:34:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v9] tools/lib/traceevent: Man pages for tep plugins APIs
Date:   Tue,  3 Sep 2019 16:34:34 +0300
Message-Id: <20190903133434.30417-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:
  tep_load_plugins(),
  tep_unload_plugin()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
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
2.21.0

