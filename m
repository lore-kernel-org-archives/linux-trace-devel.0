Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F07C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964C16115B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhDISts (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:49:48 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:50157 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234375AbhDISts (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:49:48 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 11:49:30 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 4D98521081;
        Fri,  9 Apr 2021 11:49:34 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Yordan Karadzhov <y.karadz@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH v2 1/2] libtracefs: Have the option mask function return a const pointer
Date:   Fri, 9 Apr 2021 14:49:29 -0400
Message-ID: <20210409184930.2241303-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210409184930.2241303-1-rostedt@goodmis.org>
References: <20210409184930.2241303-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As the pointer returned by the tracefs_options_get_*() point to the
instance field, it must not be freed or modified by the caller. Have the
return value of the mask be a constant, and update the documentation to
reflect this.

Also fixed the documentation about supported options. If an option is
supported in the top level instance, it may *not* be supported in a
created instance. Currently all options supported in the created instance
are also supported at the top level, but there's no guarantee that will be
the case in the future. All created instances (mkdir in instances
directory) have the same supported options.

Link: https://lore.kernel.org/linux-trace-devel/CAPpZLN7G4AttMVFhwtf_YVouRtXhtNyHBK7QqEZWzAEeGhU_9Q@mail.gmail.com/

Suggested-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-option-get.txt | 15 +++++++++------
 include/tracefs.h                       |  4 ++--
 src/tracefs-tools.c                     | 10 ++++++----
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index 4f5291e..f1c3502 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct tracefs_instance pass:[*]_instance_);
+const struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
-struct tracefs_options_mask pass:[*]*tracefs_options_get_enabled*(struct tracefs_instance pass:[*]_instance_);
+const struct tracefs_options_mask pass:[*]*tracefs_options_get_enabled*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_option_is_enabled*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
 --
 
@@ -25,11 +25,12 @@ depend on the kernel version and the kernel configuration.
 
 The _tracefs_options_get_supported()_ function gets all ftrace options supported by the system in
 the given _instance_. If _instance_ is NULL, supported options of the top trace instance are
-returned. The set of supported options must be the same in all trace instances.
+returned. The set of supported options is the same in all created trace instances, but may be different
+than the top trace instance.
 
 The _tracefs_option_is_supported()_ function checks if the option with given _id_ is supported by
 the system in the given _instance_. If _instance_ is NULL, the top trace instance is used. If an
-option is supported at the top trace instance, it must be supported in all trace instances also.
+option is supported at the top trace instance, it it may not be supported in a created trace instance.
 
 The _tracefs_options_get_enabled()_ function gets all ftrace options, currently enabled in
 the given _instance_. If _instance_ is NULL, enabled options of the top trace instance are returned.
@@ -39,8 +40,10 @@ given _instance_. If _instance_ is NULL, the top trace instance is used.
 
 RETURN VALUE
 ------------
-The _tracefs_options_get_supported()_ and _tracefs_options_get_enabled()_ functions return pointer
-to allocated bitmask with trace options, or NULL in case of an error.
+The _tracefs_options_get_supported()_ and _tracefs_options_get_enabled()_ functions, on success,
+return a pointer to the bitmask within the instance, or a global bitmask for the top level,
+or NULL in case of an error. As the returned bitmask is part of the instance structure (or a
+global variable) and must not be freed or modified.
 
 The _tracefs_option_is_supported()_ and _tracefs_option_is_enabled()_ functions return true if the
 option in supported / enabled, or false otherwise.
diff --git a/include/tracefs.h b/include/tracefs.h
index c761d12..2dc29b3 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,9 +145,9 @@ enum tracefs_option_id {
 struct tracefs_options_mask;
 bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
 				enum tracefs_option_id id);
-struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
+const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
-struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
+const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
 bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 43c2ee6..fa09da5 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -208,8 +208,8 @@ enum tracefs_option_id tracefs_option_id(const char *name)
 	return TRACEFS_OPTION_INVALID;
 }
 
-static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
-						      bool enabled)
+const static struct tracefs_options_mask *
+trace_get_options(struct tracefs_instance *instance, bool enabled)
 {
 	pthread_mutex_t *lock = instance ? &instance->lock : &toplevel_lock;
 	struct tracefs_options_mask *bitmask;
@@ -258,7 +258,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
  * Returns bitmask structure with all trace options, supported in given instance,
  * or NULL in case of an error.
  */
-struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
+const struct tracefs_options_mask *
+tracefs_options_get_supported(struct tracefs_instance *instance)
 {
 	return trace_get_options(instance, false);
 }
@@ -270,7 +271,8 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
  * Returns bitmask structure with all trace options, enabled in given instance,
  * or NULL in case of an error.
  */
-struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
+const struct tracefs_options_mask *
+tracefs_options_get_enabled(struct tracefs_instance *instance)
 {
 	return trace_get_options(instance, true);
 }
-- 
2.29.2

