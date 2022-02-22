Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721DAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiBVRcN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiBVRcN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:32:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBC010E079
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4480E61324
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9BC340E8;
        Tue, 22 Feb 2022 17:31:44 +0000 (UTC)
Date:   Tue, 22 Feb 2022 12:31:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222123143.6fbb81a6@gandalf.local.home>
In-Reply-To: <20220218225058.12701-2-beaub@linux.microsoft.com>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Feb 2022 14:50:56 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index bf157e1..e768cba 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -119,4 +119,28 @@ int trace_rescan_events(struct tep_handle *tep,
>  struct tep_event *get_tep_event(struct tep_handle *tep,
>  				const char *system, const char *name);
>  
> +/* Internal interface for ftrace user events */
> +
> +struct tracefs_user_event_group;
> +
> +struct tracefs_user_event
> +{
> +	int write_index;
> +	int status_index;
> +	int iovecs;
> +	int rels;
> +	int len;
> +	struct tracefs_user_event_group *group;
> +	struct tracefs_user_event *next;
> +};
> +
> +struct tracefs_user_event_group
> +{
> +	int fd;
> +	int mmap_len;
> +	char *mmap;
> +	pthread_mutex_t lock;
> +	struct tracefs_user_event *events;
> +};
> +
>  #endif /* _TRACE_FS_LOCAL_H */
>



> +/**
> + * tracefs_user_event_test - Tests if an event is currently enabled
> + * @event: User event to test
> + *
> + * Tests if the @event is valid and currently enabled on the system.
> + *
> + * Return true if enabled, false otherwise.
> + */
> +bool tracefs_user_event_test(struct tracefs_user_event *event)
> +{
> +	return event && event->group->mmap[event->status_index] != 0;
> +}
> +

I was thinking we could even make the above faster by making it a static
inline in the tracefs.h header file.

In tracefs.h:

struct tracefs_user_event {
	char			*enable;
};

static inline bool tracefs_user_event_test(struct tracefs_user_event *event)
{
	return event && event->enable[0] != 0;
}

Then in tracefs-local.h:

struct tracefs_user_event_internal {
	struct tracefs_user_event	event_external;
	[...]
};

Then have in tracefs_user_event_register():

	event->write_index = reg.write_index;
	event->status_index = reg.status_index;
	event->group = group;

	event->event_external.enable = &event->group->mmap[event->status_index];

	[..]

	return &event->event_external;

All the other functions wouldn't even have to do a container_of() call, as
the event_external will be the first field in the struct it needs.

	struct tracefs_user_event_internal *event = (struct tracefs_user_event_internal *)event_external;

Or make the above a helper function:

#define INTERNAL_EVENT(e) ((struct tracefs_user_event_internal *)e)

	struct tracefs_user_event_internal *event = INTERNAL_EVENT(event_external);


Then we save on the function call, and allow the code to do the test inline.

-- Steve
