Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7ACC4363A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 14:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D910207BC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 14:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJ2OE0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 10:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgJ2OEZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 10:04:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A822076B;
        Thu, 29 Oct 2020 14:04:23 +0000 (UTC)
Date:   Thu, 29 Oct 2020 10:04:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data
 streams
Message-ID: <20201029100421.33720af1@gandalf.local.home>
In-Reply-To: <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-8-y.karadz@gmail.com>
        <20201012201847.1218c974@oasis.local.home>
        <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 12:10:36 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >> +/**
> >> + * @brief Get the name of the command/task from its Process Id.
> >> + *
> >> + * @param sd: Data stream identifier.
> >> + * @param pid: Process Id of the command/task.
> >> + */
> >> +char *kshark_comm_from_pid(int sd, int pid)  
> > 
> > I wonder if we should abstract this further, and call it
> > "kshark_name_from_id()", as comm and pid are specific to processes, and
> > we may have a stream that will represent something other than processes.
> >   
> 
> This is just a helper function that wraps the corresponding method of 
> the interface. In the future we can add a similar helper/wrapper 
> function with different name if we have streams that contain no processes.
> 
> However, you are actually making a very good point. It may be even 
> better if we abstract the interface itself, instead of trying to have 
> more abstract method names. We can keep the existing interface of 
> methods unchanged, but in the definition of "struct kshark_data_stream" 
> make the interface void*
> 
> struct kshark_data_stream {
> 	/** Data stream identifier. */
> 	uint8_t			stream_id;
> 
> ....
> 
> 	/** List of Plugin's Draw handlers. */
> 	struct kshark_draw_handler		*draw_handlers;
> 
> 	/**
> 	 * Abstract interface of methods used to operate over the data
> 	 * from a given stream. An implementation must be provided.
> 	 */
> 	void	*interface;
> };
> 
> and then the wrapping functions may look like this
> 
> char *kshark_comm_from_pid(int sd, int pid)
> {
> 	struct kshark_data_stream_interface *interface;
> 	struct kshark_context *kshark_ctx = NULL;
> 	struct kshark_data_stream *stream;
> 	struct kshark_entry e;
> 
> 	if (!kshark_instance(&kshark_ctx))
> 		return NULL;
> 
> 	stream = kshark_get_data_stream(kshark_ctx, sd);
> 	if (!stream)
> 		return NULL;
> 
> 	interface = stream->interface;
> 	if (!interface || !interface->get_task)
> 		return NULL;
> 
> 	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
> 	e.pid = pid;
> 
> 	return interface->get_task(stream, &e);
> }
> 
> And in the future we can add more interface implementations and more 
> helper functions.
> 
> What do you think?


Do we need to make the interface "void *" and not just a non defined type
"struct kshark_data_stream_interface *"?

Just have:

struct kshark_data_stream_interface;

And then reference it without defining it, and have the streams define it.
If you need this to have inheritance and a bit of polymorphism you can do
that too :-) That is, if you want this interface to have something common
among all streams.

struct kshark_data_stream_interface {
	int		type;
	int		common_data;
};

then local to the file that implements it:

struct data_stream_interface {
	struct kshark_data_stream_interface	kinterface;
	int					unique_data;
};


{
	struct data_stream_interface	*interface;


	interface = (struct data_stream_interface *)stream->interface;

	if (interface->kinterface.type != my_type)
		return (or error);

	unique_data = interface->unique_data;

}


This is even how the trace events work in the kernel. For example:

struct trace_entry {
	unsigned short		type;
	unsigned char		flags;
	unsigned char		preempt_count;
	int			pid;
};

struct kprobe_trace_entry_head {
	struct trace_entry	ent;
	unsigned long		ip;
};

struct kretprobe_trace_entry_head {
	struct trace_entry	ent;
	unsigned long		func;
	unsigned long		ret_ip;
};

-- Steve
