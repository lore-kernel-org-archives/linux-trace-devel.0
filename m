Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FE6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiBVRrF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiBVRrE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:47:04 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1905C6D942
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:46:38 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id B66BB20C31B2;
        Tue, 22 Feb 2022 09:46:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B66BB20C31B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645551997;
        bh=vrwxPo60VxFLoQ45pWrf9HCyT5TZ4IqD1tlenzUYfkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DskXl86oxa5LukUJr7LPbyKp/Nq514pXwQ5iCl0AKfdXlYvQkeFBfMk898Fr+CJnd
         SyrzueKkJFKw9ppkkSuWdUP2rmgiEDZf6Z7mWt0wz4cEIhp8UvJ6BSy+W+ks52K6/e
         U+2si3pLJ6LcxhNiOUShiGH3I6gZc+Jwu3QALfTk=
Date:   Tue, 22 Feb 2022 09:46:34 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Message-ID: <20220222174634.GB1709@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220218225058.12701-2-beaub@linux.microsoft.com>
 <20220222123143.6fbb81a6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222123143.6fbb81a6@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 12:31:43PM -0500, Steven Rostedt wrote:
> On Fri, 18 Feb 2022 14:50:56 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> > index bf157e1..e768cba 100644
> > --- a/include/tracefs-local.h
> > +++ b/include/tracefs-local.h
> > @@ -119,4 +119,28 @@ int trace_rescan_events(struct tep_handle *tep,
> >  struct tep_event *get_tep_event(struct tep_handle *tep,
> >  				const char *system, const char *name);
> >  
> > +/* Internal interface for ftrace user events */
> > +
> > +struct tracefs_user_event_group;
> > +
> > +struct tracefs_user_event
> > +{
> > +	int write_index;
> > +	int status_index;
> > +	int iovecs;
> > +	int rels;
> > +	int len;
> > +	struct tracefs_user_event_group *group;
> > +	struct tracefs_user_event *next;
> > +};
> > +
> > +struct tracefs_user_event_group
> > +{
> > +	int fd;
> > +	int mmap_len;
> > +	char *mmap;
> > +	pthread_mutex_t lock;
> > +	struct tracefs_user_event *events;
> > +};
> > +
> >  #endif /* _TRACE_FS_LOCAL_H */
> >
> 
> 
> 
> > +/**
> > + * tracefs_user_event_test - Tests if an event is currently enabled
> > + * @event: User event to test
> > + *
> > + * Tests if the @event is valid and currently enabled on the system.
> > + *
> > + * Return true if enabled, false otherwise.
> > + */
> > +bool tracefs_user_event_test(struct tracefs_user_event *event)
> > +{
> > +	return event && event->group->mmap[event->status_index] != 0;
> > +}
> > +
> 
> I was thinking we could even make the above faster by making it a static
> inline in the tracefs.h header file.
> 
> In tracefs.h:
> 
> struct tracefs_user_event {
> 	char			*enable;
> };
> 
> static inline bool tracefs_user_event_test(struct tracefs_user_event *event)
> {
> 	return event && event->enable[0] != 0;
> }
> 
> Then in tracefs-local.h:
> 
> struct tracefs_user_event_internal {
> 	struct tracefs_user_event	event_external;
> 	[...]
> };
> 
> Then have in tracefs_user_event_register():
> 
> 	event->write_index = reg.write_index;
> 	event->status_index = reg.status_index;
> 	event->group = group;
> 
> 	event->event_external.enable = &event->group->mmap[event->status_index];
> 
> 	[..]
> 
> 	return &event->event_external;
> 
> All the other functions wouldn't even have to do a container_of() call, as
> the event_external will be the first field in the struct it needs.
> 
> 	struct tracefs_user_event_internal *event = (struct tracefs_user_event_internal *)event_external;
> 
> Or make the above a helper function:
> 
> #define INTERNAL_EVENT(e) ((struct tracefs_user_event_internal *)e)
> 
> 	struct tracefs_user_event_internal *event = INTERNAL_EVENT(event_external);
> 
> 
> Then we save on the function call, and allow the code to do the test inline.

Yes, I was thinking along the same lines. I saw how things were split
between private / public in the headers and wasn't sure how to
accomplish this.

What you have above seems like a great way to accomplish this without exposing
too much out.

Thanks,
-Beau
