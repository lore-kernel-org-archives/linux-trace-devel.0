Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE3BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 02:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE31260E78
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 02:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhJMCQk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 22:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhJMCQk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 22:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D29560E0C;
        Wed, 13 Oct 2021 02:14:37 +0000 (UTC)
Date:   Tue, 12 Oct 2021 22:14:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC] Modifications of some 'hist' APIs
Message-ID: <20211012221434.2de54ab6@oasis.local.home>
In-Reply-To: <5439fe13-8d78-2fe6-3749-5e60cf10151c@gmail.com>
References: <20210924095702.151826-1-y.karadz@gmail.com>
        <5439fe13-8d78-2fe6-3749-5e60cf10151c@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Oct 2021 16:55:29 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Hi Steven et al.
> 
> I would like to suggest some further modifications of the current APIs of libtracefs. The problem that I am trying to 
> solve with this modifications is the unnecessary and potentially confusing variety of patterns used when implementing 
> the APIs for dealing with 'instances', 'kprobes', 'histigrams' and 'synthetic events'. I believe that 
> unifying/templating the structure of those APIs will be beneficial and will make the usage fare more intuitive. I am 
> posting below a pseudo code for one possible implementation of such template APIs that can be used as a starting point 
> for a discussion.

As we discussed. I think instances are a different beast than kprobes,
histograms and sythetic events, as instances is a platform for events,
where as the others are just events or part of events. So it's fine if
instances had a different interface.

> 
> /**
>   * tracefs_XXX_alloc - allocate a new tracefs_XXX descriptor. This only
>   * initializes the descriptor, it does not introduce any changes on the
>   * system.

This is fine, for all (including instances).

>   *
>   * @arguments: Some arguments specific for the type of the object ...
>   *
>   * Returns a newly allocated tracefs_XXX descriptor objext, or NULL in case
>   * of an error. The returned instance must be freed by tracefs_XXX_free().
>   */
> struct tracefs_XXX *tracefs_XXX_alloc(arguments);
> 
> /**
>   * tracefs_XXX_create - creates new tracefs_XXX object on the system.
>   * This method calls tracefs_XXX_alloc() internally.

This is fine too.

>   *
>   * @arguments: Some arguments specific for the type of the object ...
>   * This function should not take an instance as argument. Otherwise the
>   * same instance will have to be passed to tracefs_XXX_destroy(), which
>   * can be a problem in some more sophisticated use-cases.
>   *
>   * Returns 0 on succes and -1 on error. On error, errno is set to:
>   * EBUSY - the object already exists on the system.

As we discussed, this is is fine for kprobes, histograms and synthetic
events, but for instances, it can still succeed, but the user can check
if it was created or not.

We could add: tracefs_instance_create_unique() that will fail if the
instance already exists.

>   * ENOMEM - memory allocation failure.
>   * ENIVAL - a parameter is passed as NULL or value that should not be or
>   * a problem writing into the system.
>   */
> struct tracefs_XXX *tracefs_XXX_create(arguments);
> 
> /**
>   * tracefs_XXX_find - find a tracefs_XXX object that already exists on the
>   * system. This method calls tracefs_XXX_alloc() internally.

I'm not sure we need this, as it only really makes sense for instances,
and above we already talked about that.

If we were to have this interface for the other types, I would suggest
calling it "open" and not "find". But creating kprobes / histograms and
synthetic events may not be as trivial, as building it would require
knowing the details of how they are used. Kprobes and histograms may be
possible, but the synthetic events will prove to be more difficult.

>   *
>   * @arguments: Some arguments specific for the type of the object ...
>   * This function should not take an instance as argument. Otherwise the same
>   * instance will have to be passed to tracefs_XXX_destroy(), which can be a
>   * problem in some more sophisticated use-cases.
>   *
>   * Returns tracefs_XXX descriptor on succes and NULL if the object do not
>   * exist on the system or in the case of an error. On error, errno is set to:
>   * ENOMEM - memory allocation failure.
>   * ENIVAL - a parameter is passed as NULL or value that should not be or
>   * a problem writing into the system.
>   */
> struct tracefs_XXX *tracefs_XXX_find(arguments);
> 
> /**
>   * tracefs_instance_destroy - Remove/clears a tracefs_XXX objext from the
>   * system. tracefs_XXX_free() must be called in order to free the memory used
>   * by the descriptor itself.
>   *
>   * @obj: Pointer to the tracefs_XXX descriptor of the objext to be destroyed.
>   * @force: If false the object is not guaranteed to be destroyed. If @force
>   * is true, all tangled objects that prevent the destruction of the object
>   * will be destroyed as well.

As stated before, the force may still be a best effort attempt.

>   *
>   * This function should not take any other arguments.
>   *
>   * Returns -1 in case of an error or if the object failed to destroy.
>   * 0 otherwise.
>   */
> int tracefs_XXX_destroy(struct tracefs_XXX *obj, bool force);
> 
> /**
>   * tracefs_XXX_free - Free a tracefs_XXX descriptor, previously allocated
>   * by tracefs_XXX_alloc, tracefs_XXX_create() or tracefs_XXX_find().
>   *
>   * @obj: Pointer to the tracefs_XXX descriptor objext to be freed.
>   *
>   * This function should not take any other arguments.
>   */
> void tracefs_XXX_free(struct tracefs_XXX *obj);
> 
> /**
>   * tracefs_XXX_YYY - Method implementing the user action 'YYY' (can be
>   * enable/disable, start/stop/clear, ... etc.)
>   *
>   * @obj: Pointer to the tracefs_XXX objext for witch the user action will
>   * apply.
>   * @instance: Ftrace instance, can be NULL for top tracing instance.
>   * @more_arguments: Some additional arguments specific for the type XXX and
>   * the action YYY.

Sounds fine to me.

Thanks for explicitly specifying the details of the interface. 

-- Steve


>   */
> void/int tracefs_XXX_YYY(struct tracefs_XXX *obj,
> 			 struct tracefs_instance *inst,
> 			 more_arguments);
> 
> 
> Thanks a lot!
> Yordan
> 

