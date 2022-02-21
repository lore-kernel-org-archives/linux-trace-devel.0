Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7FAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 18:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiBUSJY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 13:09:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiBUSGb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 13:06:31 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3773DE011
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 09:57:29 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id BFA1720C2FA0;
        Mon, 21 Feb 2022 09:57:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BFA1720C2FA0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645466248;
        bh=v7Iz18qXcXNmJIF/EjSm0Ti/AN9qiG2TrZomK9pPsvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nLXw9CVD0Yq3Oo8ZUsb1OyNal6VC8QW7DenOoUkdLBRkOIiRs4HMj3XAD2Ig6NFDL
         u91BIARyMsrvMWmIlUjvMSbaNITDKe6sDsWCYupbNMDNnfPggNCS1dFQadb4GLM/w9
         a1o4R4LBuVbe3UJ5QfEATrklWwiDF/20KPBH/Q9k=
Date:   Mon, 21 Feb 2022 09:57:20 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Message-ID: <20220221175720.GA1738@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220218225058.12701-2-beaub@linux.microsoft.com>
 <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 21, 2022 at 01:34:00PM +0200, Yordan Karadzhov wrote:
> 
> 
> On 19.02.22 г. 0:50 ч., Beau Belgrave wrote:
> > diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> > index bf157e1..e768cba 100644
> > --- a/include/tracefs-local.h
> > +++ b/include/tracefs-local.h
> > @@ -119,4 +119,28 @@ int trace_rescan_events(struct tep_handle *tep,
> >   struct tep_event *get_tep_event(struct tep_handle *tep,
> >   				const char *system, const char *name);
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
> >   #endif /* _TRACE_FS_LOCAL_H */
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index 1848ad0..7871dfe 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -571,4 +571,64 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
> >   struct tep_event *
> >   tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
> > +/* User events */
> > +enum tracefs_uevent_type {
> > +	TRACEFS_UEVENT_END,
> > +	TRACEFS_UEVENT_u8,
> > +	TRACEFS_UEVENT_s8,
> > +	TRACEFS_UEVENT_u16,
> > +	TRACEFS_UEVENT_s16,
> > +	TRACEFS_UEVENT_u32,
> > +	TRACEFS_UEVENT_s32,
> > +	TRACEFS_UEVENT_u64,
> > +	TRACEFS_UEVENT_s64,
> > +	TRACEFS_UEVENT_string,
> > +	TRACEFS_UEVENT_struct,
> > +	TRACEFS_UEVENT_varray,
> > +	TRACEFS_UEVENT_vstring,
> > +};
> > +
> > +enum tracefs_uevent_flags {
> > +	/* None */
> > +	TRACEFS_UEVENT_FLAG_NONE = 0,
> > +
> > +	/* When BPF is attached, use iterator/no copy */
> > +	TRACEFS_UEVENT_FLAG_bpf_iter = 1 << 0,
> > +};
> > +
> > +struct tracefs_uevent_item {
> > +	/* Type of item */
> > +	enum tracefs_uevent_type type;
> > +
> > +	/* Length of data, optional during register */
> > +	int len;
> > +
> > +	union {
> > +		/* Used during write */
> > +		const void *data;
> > +
> > +		/* Used during register */
> > +		const char *name;
> > +	};
> > +};
> > +
> > +struct tracefs_user_event;
> > +struct tracefs_user_event_group;
> > +
> 
> We've been trying to follow certain naming convention for the APIs and to
> provide similar usage patterns for all types of trace events that are
> supported by the library so far (dynamic, synthetic and histograms). If
> 'XXX' is the type of the event ('user_event' in your case), the pattern
> looks like this:
> 
> tracefs_XXX_alloc() - this constructor just allocates memory and initializes
> the descriptor object without modifying anything on the system. We allow for
> multiple constructor function, in the case when your objects has to many
> possible configurations and it is hard to do everything in a single API.
> Looking into your implementation, such constructor can do half of the work
> done in 'tracefs_user_event_group_create()'
> 
> int tracefs_XXX_create(struct tracefs_XXX *evt) - This is the API that
> actually adds your event on the system. Note that it takes just one argument
> that is the object itself. Again, looking into your implementation, this
> will combine the other half of tracefs_user_event_group_create() and
> tracefs_user_event_register().

Are you and Steven aligned on this convention?

The request looked slightly different:
See https://lore.kernel.org/linux-trace-devel/20220121192833.GA3128@kbox/T/#m2bcf53c373fbeaba2c46d1a053b3174171167e4e

> 
> int tracefs_XXX_destroy(struct tracefs_XXX *evt) This API removes your event
> from the system. The first argument is again the object. If needed, here you
> can use a second argument that is 'bool force'.
> 
> int tracefs_XXX_free(struct tracefs_XXX *evt) - just to free the memory
> 
> 
> > +struct tracefs_user_event_group *tracefs_user_event_group_create(void);
> > +
> > +void tracefs_user_event_group_close(struct tracefs_user_event_group *group);
> > +
> > +int tracefs_user_event_delete(const char *name);
> > +
> > +struct tracefs_user_event *
> > +tracefs_user_event_register(struct tracefs_user_event_group *group,
> > +			    const char *name, enum tracefs_uevent_flags flags,
> > +			    struct tracefs_uevent_item *items);
> > +
> > +bool tracefs_user_event_test(struct tracefs_user_event *event);
> 
> And maybe "test" is redundant. You can do the check in tracefs_XXX_create() and return an error if it fails.
> 

Test is required so user programs can tell when write should be called.
Otherwise excessive calculations and stack data are pushed for no good
reason.

> > +
> > +int tracefs_user_event_write(struct tracefs_user_event *event,
> > +			     struct tracefs_uevent_item *items);
> 
> The "write" is OK.
> 
> Maybe we can change 'tracefs_user_event' to 'tracefs_usrevent' since we already use 'tracefs_dynevent' for dynamic events.
> 
> What do you think?
> 

I'm happy to do whatever, I just want to ensure you and Steven are
aligned.

> Thanks!
> Yordan

Thanks,
-Beau
