Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22777C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E860424673
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbDrDKiv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgAVPAM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:12 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41161 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVPAM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:12 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so7154248ljc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UFYwSqbQzzhMH5vl8zY2CSKRunphQOXVq2ylRzgHbug=;
        b=IbDrDKivxUA0Grfsh6/y4nQ0oD5Kywc8PVHeqrGTr0En7KS6fqjTa2kisz3Sn6vuK9
         iwi+ELvyLbcM845KYh0eARocr3xG+tUtsd2oY7AIVnsCtdtAxsUxJnbwnywSGV5YYS9D
         PC5WD4kfoKuG47RGqPMLT8cv7pibUJnihTGMEFz4hifrmVAqUMO0qcuExcW4b+5BeRKm
         dvKRgmEJ+FkYsTmVjz6GG07nTjSpXIpU4jCXeq/hzF6l7xL3Xmwh39IivKCK06kPKbP3
         unHXHQztx+jmvurPGJrCkVzOYwWqiCDBWqWeB0igrSB1Jos+/Apye3mEAKVojc910Ou2
         L6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UFYwSqbQzzhMH5vl8zY2CSKRunphQOXVq2ylRzgHbug=;
        b=nDeObtfQG+ocGvioG89JF/DiGGBJF3saXdDf0nkOjc6GSF2Rr38XnBkuFrtsrOp6uH
         R3chMHuUyb5OXdu5mfiJ4YSFr6NoZ+jg3KESMVb8W1twkD+iKEImPswdPXdrqgGMbk1K
         fu64ID5hFUKNVipfc0HyTZQTqcAe7baxYGxd/GYbk/VPO+XiXifEgz43pcG8ln+PEULn
         HjUtL3Ao922i0yBEDla/cG/fI1/OxM+m6FblpKoiRVy4JqFYZ3+xVLCKXoIFDTcRWfrL
         boPtc5PBW7003HXxJZdcug0BAm1eR8h74QV3+GZdL5gDpzL0REWiWMoIKVRYb/2kmZ1M
         YtIw==
X-Gm-Message-State: APjAAAUYow8p+7ME5+hkAcuaCFKuNPVsZhjFD4pyTnpx8WmCSQ0AJSAI
        LKd5fKnsqgtHe8jVbWZrP9M=
X-Google-Smtp-Source: APXvYqx0o+MqoPlGrmhvdxJ7zsH0I4ubNSmhHX6p7i1/QOr3QawAcKawGaDTfMz0XZ5YB0Nl/QZNwA==
X-Received: by 2002:a05:651c:204f:: with SMTP id t15mr20427210ljo.240.1579705210561;
        Wed, 22 Jan 2020 07:00:10 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/7] trace-cmd,libtraceevent: Check for plugin duplication
Date:   Wed, 22 Jan 2020 16:59:59 +0200
Message-Id: <20200122150002.763233-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When loading new plugin, check if plugin with the same
file name is already registered. If there is such plugin,
unload it and then load the new one.
In case of duplication, the last one wins.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 50 +++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index e53b09c..a33cf09 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -432,16 +432,60 @@ void tep_print_plugins(struct trace_seq *s,
 	}
 }
 
+
+static void unload_plugin(void *handle, struct tep_handle *tep)
+{
+	tep_plugin_unload_func func;
+
+	if (!handle)
+		return;
+	func = dlsym(handle, TEP_PLUGIN_UNLOADER_NAME);
+	if (func)
+		func(tep);
+	dlclose(handle);
+}
+
+static struct tep_plugin_list *
+detach_plugin(const char *name, struct tep_plugin_list **plist)
+{
+	struct tep_plugin_list *plugins = *plist;
+	struct tep_plugin_list *prev = NULL;
+	char *file;
+
+	while (plugins) {
+		file = strrchr(plugins->name, '/');
+		if (file)
+			file++;
+		else
+			file = plugins->name;
+		if (!strcmp(file, name)) {
+			if (prev)
+				prev->next = plugins->next;
+			else
+				*plist = plugins->next;
+			return plugins;
+		}
+		prev = plugins;
+		plugins = plugins->next;
+	}
+
+	return NULL;
+}
+
 static void
 load_plugin(struct tep_handle *tep, const char *path,
 	    const char *file, void *data)
 {
 	struct tep_plugin_list **plugin_list = data;
+	struct tep_plugin_list *old;
 	tep_plugin_load_func func;
 	struct tep_plugin_list *list;
 	char *plugin;
 	void *handle;
 	int ret;
+	old = detach_plugin(file, plugin_list);
+	if (old)
+		unload_plugin(old->handle, tep);
 
 	ret = asprintf(&plugin, "%s/%s", path, file);
 	if (ret < 0) {
@@ -652,16 +696,12 @@ void tep_free_plugin_paths(struct tep_handle *tep)
 void
 tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 {
-	tep_plugin_unload_func func;
 	struct tep_plugin_list *list;
 
 	while (plugin_list) {
 		list = plugin_list;
+		unload_plugin(list->handle, tep);
 		plugin_list = list->next;
-		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
-		if (func)
-			func(tep);
-		dlclose(list->handle);
 		free(list->name);
 		free(list);
 	}
-- 
2.24.1

