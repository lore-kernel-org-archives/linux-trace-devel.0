Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAAEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 10:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357102AbhLBLC5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 06:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhLBLC5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 06:02:57 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD4DC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 02:59:34 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z5so49305798edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 02:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F1vA4kFyK6UD2rG8jEiA57WpoTw+4hIKJLNY8aHqyIc=;
        b=jwyrW4/GmahnCm0a6N3EE9/nxFP0nF/FAXWpFlQgqYb+j3ZyvRAyp4ovGlUjjlxoIb
         eHLTsD7u+rLaMHTNXrNX4WWAHAHHAvv/glABQb5WPMI3OStdascaKr4sbZwV1OG2UDCJ
         dh56tK3r8iFSpjBXEWrjrnWjMg6YSQD4Cc4hgp+CxBTFjRjyan23jbZBBprfY+QyzWQj
         pEGpnaNQOte8x/J1UIHIxo8sZ3hGMgmtjpY67AXcer/QXcfOOe+GfEaGPvVuQMEDdRDz
         O7sGcL3Rc1ZTuqD4H0mI+YN1cO75UPlChGVnEZPVIvFE4cFGPc0O+J1P/46GjqPI/Ta9
         4NRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F1vA4kFyK6UD2rG8jEiA57WpoTw+4hIKJLNY8aHqyIc=;
        b=ICrF54BKpRTaZjzEHT14enYX1axwZWw4obryHKnJRLdYauHLjNvS3tmuYe4jmsfQo3
         n6CQb7eamQuVZUSzYjgY7huH6SryC/fwvHs06QeBcFiAUjAGV37wE6fgXpnive0X/kUb
         XUCXtC2rUR8ewlPFiEHPCcZzJUpbPyU0ii5Q5fqX90ZstU1NRCYxpy+ievpdztSgUMXf
         XFrSsMmmTzGORODvYMG6Bn+7a7cqdmlrWxCpc5l4FavHaM533B+4iX7rTtHNj0adNkWs
         8PZ9zd7rn5Mz5xkxHsTR1jq7nkxa3YAoJ/oBrafIAK69fpe8ZFamPsYOUcOznNoUfl8Y
         rZPA==
X-Gm-Message-State: AOAM532JkZi9hi+t02U1wZE+Drqw3k83NGrBbBIpB+ja8/1dS3yshJBC
        PusJb4gl0FzbtRdPIpOy3vYjyFVIf1bvQg==
X-Google-Smtp-Source: ABdhPJw6+y9JC9xG/A8vFMw3lWWjTQwn1y198boEkuE2mscogSC1rBJv8WF1p9kCqfdW+4QVcwl11A==
X-Received: by 2002:a17:906:2590:: with SMTP id m16mr14765674ejb.38.1638442773385;
        Thu, 02 Dec 2021 02:59:33 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e19sm1852930edu.47.2021.12.02.02.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 02:59:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/4] libtracefs: New API for applying filter on event
Date:   Thu,  2 Dec 2021 12:59:26 +0200
Message-Id: <20211202105926.32581-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202105926.32581-1-tz.stoyanov@gmail.com>
References: <20211202105926.32581-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no API for applying a filter string on event. Existing APIs
only constructs and verifies the filter string. Even though the actual
applying is just writing into the event's filter file, it is good to
have a dedicated API for that:
	tracefs_event_filter_apply()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-filter.txt | 12 ++++++++++--
 include/tracefs.h                   |  5 +++++
 src/tracefs-filter.c                | 18 ++++++++++++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 23a2abf..7db3d60 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_filter_string_append, tracefs_filter_string_verify - Add and verify event filters
+tracefs_filter_string_append, tracefs_filter_string_verify, tracefs_event_apply_filter -
+Add, verify and apply event filters
 
 SYNOPSIS
 --------
@@ -15,7 +16,7 @@ int tracefs_filter_string_append(struct tep_event pass:[*]event, char pass:[**]
 				 struct tracefs_filter type, const char pass:[*]field,
 				 enum tracefs_synth_compare compare, const char pass:[*]val);
 int tracefs_filter_string_verify(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);
-
+int tracefs_event_filter_apply(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event, const char pass:[*]filter);
 --
 
 DESCRIPTION
@@ -66,6 +67,8 @@ error in the syntax, and _err_ is not NULL, then it will be allocated with an
 error message stating what was found wrong with the filter. _err_ must be freed
 with *free*().
 
+*tracefs_event_filter_apply*() applies given _filter_ string on _event_ in given _instance_.
+
 RETURN VALUE
 ------------
 *tracefs_filter_string_append*() returns 0 on success and -1 on error.
@@ -75,6 +78,8 @@ is an error, and _errno_ is not *ENOMEM*, then _err_ is allocated and will
 contain a string describing what was found wrong with _filter_. _err_ must be
 freed with *free*().
 
+*tracefs_event_filter_apply*() returns 0 on success and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
@@ -269,6 +274,9 @@ int main (int argc, char **argv)
 		}
 	}
 
+	if (tracefs_event_filter_apply(NULL, event, new_filter))
+		fprintf(stderr, "Failed to apply filter on event");
+
 	tep_free(tep);
 
 	printf("Created new filter: '%s'\n", new_filter);
diff --git a/include/tracefs.h b/include/tracefs.h
index 383974b..ac92dca 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -476,6 +476,10 @@ int tracefs_filter_string_append(struct tep_event *event, char **filter,
 int tracefs_filter_string_verify(struct tep_event *event, const char *filter,
 				 char **err);
 
+int tracefs_event_filter_apply(struct tracefs_instance *instance,
+			       struct tep_event *event, const char *filter);
+
+
 /** Deprecated do not use: Instead use tracefs_filter_string_append() **/
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				enum tracefs_filter type,
@@ -486,6 +490,7 @@ int tracefs_event_append_filter(struct tep_event *event, char **filter,
 int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
 				char **err);
 
+
 #define TRACEFS_TIMESTAMP "common_timestamp"
 #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
 
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index e65fd94..7bc36fe 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -746,6 +746,24 @@ int tracefs_filter_string_verify(struct tep_event *event, const char *filter,
 	return 0;
 }
 
+/**
+ * tracefs_event_filter_apply - apply given filter on event in given instance
+ * @instance: The instance in which the filter will be applied (NULL for toplevel).
+ * @event: The event to apply the filter on.
+ * @filter: The filter to apply.
+ *
+ * Apply the @filter to given @event in givem @instance. The @filter string
+ * should be created with tracefs_filter_string_append().
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int tracefs_event_filter_apply(struct tracefs_instance *instance,
+			       struct tep_event *event, const char *filter)
+{
+	return tracefs_event_file_write(instance, event->system, event->name,
+					"filter", filter);
+}
+
 /** Deprecated **/
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				enum tracefs_filter type,
-- 
2.33.1

