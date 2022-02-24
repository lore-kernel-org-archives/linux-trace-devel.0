Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4DAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 23:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiBXX4b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiBXX4a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 18:56:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915DE29EB9F
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:55:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D5CD61CBB
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 23:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29649C340EF;
        Thu, 24 Feb 2022 23:55:58 +0000 (UTC)
Date:   Thu, 24 Feb 2022 18:55:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 3/3] libtracefs: Move initialization below a null test.
Message-ID: <20220224185556.2771ad18@gandalf.local.home>
In-Reply-To: <20220224234823.1190425-3-irogers@google.com>
References: <20220224234823.1190425-1-irogers@google.com>
        <20220224234823.1190425-3-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Feb 2022 15:48:23 -0800
Ian Rogers <irogers@google.com> wrote:

> Computing the address from a NULL pointer results in undefined behavior
> which things like undefined behavior sanitizer promote into real
> failures.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  src/tracefs-dynevents.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 61804b9..8fee474 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -724,13 +724,18 @@ tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
>  		      char **event, char **prefix, char **addr, char **format)
>  {
>  	char **lv[] = { system, event, prefix, addr, format };
> -	char **rv[] = { &dynevent->system, &dynevent->event, &dynevent->prefix,
> -			&dynevent->address, &dynevent->format };
> +	char **rv[] = { NULL, NULL, NULL, NULL, NULL };
>  	int i;

I don't really like the NULL initialization done like this.

What about just adding a helper function. That is.

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 61804b9d9d5e..48bb26a96c58 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -704,24 +704,9 @@ __hidden int dynevent_get_count(unsigned int types, const char *system)
 	return all;
 }
 
-/**
- * tracefs_dynevent_info - return details of a dynamic event
- * @dynevent: A dynamic event context, describing given dynamic event.
- * @group: return, group in which the dynamic event is configured
- * @event: return, name of the dynamic event
- * @prefix: return, prefix string of the dynamic event
- * @addr: return, the function and offset (or address) of the dynamic event
- * @format: return, the format string of the dynamic event
- *
- * Returns the type of the dynamic event, or TRACEFS_DYNEVENT_UNKNOWN in case of an error.
- * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
- * If a valid pointer is passed, in case of success - a string is allocated and returned.
- * These strings must be freed with free().
- */
-
-enum tracefs_dynevent_type
-tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
-		      char **event, char **prefix, char **addr, char **format)
+static enum tracefs_dynevent_type
+dynevent_info(struct tracefs_dynevent *dynevent, char **system,
+	      char **event, char **prefix, char **addr, char **format)
 {
 	char **lv[] = { system, event, prefix, addr, format };
 	char **rv[] = { &dynevent->system, &dynevent->event, &dynevent->prefix,
@@ -754,6 +739,30 @@ error:
 	return TRACEFS_DYNEVENT_UNKNOWN;
 }
 
+/**
+ * tracefs_dynevent_info - return details of a dynamic event
+ * @dynevent: A dynamic event context, describing given dynamic event.
+ * @group: return, group in which the dynamic event is configured
+ * @event: return, name of the dynamic event
+ * @prefix: return, prefix string of the dynamic event
+ * @addr: return, the function and offset (or address) of the dynamic event
+ * @format: return, the format string of the dynamic event
+ *
+ * Returns the type of the dynamic event, or TRACEFS_DYNEVENT_UNKNOWN in case of an error.
+ * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
+ * If a valid pointer is passed, in case of success - a string is allocated and returned.
+ * These strings must be freed with free().
+ */
+enum tracefs_dynevent_type
+tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
+		      char **event, char **prefix, char **addr, char **format)
+{
+	if (!dynevent)
+		return TRACEFS_DYNEVENT_UNKNOWN;
+
+	return dynevent_info(dynevent, system, event, prefix, addr, format);
+}
+
 /**
  * tracefs_dynevent_get_event - return tep event representing the given dynamic event
  * @tep: a handle to the trace event parser context that holds the events


-- Steve
