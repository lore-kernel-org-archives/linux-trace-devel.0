Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EEEC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 05:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9036364DE8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 05:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbhBZFDN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhBZFDN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 00:03:13 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 742CF64DE8;
        Fri, 26 Feb 2021 05:02:31 +0000 (UTC)
Date:   Fri, 26 Feb 2021 00:02:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] trace-cmd: Add validation for reading and
 writing trace.dat files
Message-ID: <20210226000229.6df090a0@oasis.local.home>
In-Reply-To: <CAPpZLN4y_zvPJ0qDzAVqBhNo9aOPLzubN6BXtxKdSNgZys8Uxw@mail.gmail.com>
References: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
        <20210219053156.2235035-2-tz.stoyanov@gmail.com>
        <20210224181814.3de4e4ca@gandalf.local.home>
        <CAPpZLN4y_zvPJ0qDzAVqBhNo9aOPLzubN6BXtxKdSNgZys8Uxw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Feb 2021 06:02:17 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Steven,
> 
> On Thu, Feb 25, 2021 at 1:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri, 19 Feb 2021 07:31:55 +0200
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> > > index eddfd9eb..fc968cc9 100644
> > > --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> > > +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> > > @@ -95,6 +95,20 @@ static inline int tracecmd_host_bigendian(void)
> > >
> > >  /* --- Opening and Reading the trace.dat file --- */
> > >
> > > +enum  {
> > > +     TRACECMD_FILE_INIT,
> > > +     TRACECMD_FILE_HEADERS,
> > > +     TRACECMD_FILE_FTRACE_EVENTS,
> > > +     TRACECMD_FILE_ALL_EVENTS,
> > > +     TRACECMD_FILE_KALLSYMS,
> > > +     TRACECMD_FILE_PRINTK,
> > > +     TRACECMD_FILE_CMD_LINES,
> > > +     TRACECMD_FILE_CPU_COUNT,
> > > +     TRACECMD_FILE_OPTIONS,
> > > +     TRACECMD_FILE_CPU_LATENCY,
> > > +     TRACECMD_FILE_CPU_FLYRECORD,
> > > +};
> > > +
> > >  enum {
> > >       TRACECMD_OPTION_DONE,
> > >       TRACECMD_OPTION_DATE,
> > > @@ -115,9 +129,7 @@ enum {
> > >  enum {
> > >       TRACECMD_FL_IGNORE_DATE         = (1 << 0),
> > >       TRACECMD_FL_BUFFER_INSTANCE     = (1 << 1),
> > > -     TRACECMD_FL_LATENCY             = (1 << 2),
> > > -     TRACECMD_FL_IN_USECS            = (1 << 3),
> > > -     TRACECMD_FL_FLYRECORD           = (1 << 4),
> > > +     TRACECMD_FL_IN_USECS            = (1 << 2),
> > >  };
> > >
> > >  struct tracecmd_ftrace {
> > > @@ -150,6 +162,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
> > >  void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
> > >  void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
> > >  unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
> > > +unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
> > >  unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
> > >  int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
> > >
> > > @@ -273,6 +286,7 @@ struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handl
> > >                                                  const char *name, int cpus);
> > >
> > >  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
> > > +int tracecmd_write_cmdlines(struct tracecmd_output *handle);
> > >  int tracecmd_write_options(struct tracecmd_output *handle);
> > >  int tracecmd_append_options(struct tracecmd_output *handle);
> > >  int tracecmd_update_option(struct tracecmd_output *handle,
> > > @@ -500,7 +514,4 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
> > >  void *tracecmd_record_offset(struct tracecmd_input *handle,
> > >                            struct tep_record *record);
> > >
> > > -int save_tracing_file_data(struct tracecmd_output *handle,
> > > -                        const char *filename);  
> >
> > This turning into a static function looks unrelated to this patch, and
> > should be a separate clean up patch.  
> 
> I think it is logically from this patch. The only usage of this function
> outside of its file is for fixing the forgotten "saved_cmdlines" in
> the trace-cmd agent. This patches introduces a new API for that,
> tracecmd_write_cmdlines(), that should be used for saving the
> cmdlines as it has additional validations. I replaced the old way
> of saving the cmdlines with the new API in the whole code, which
> makes no sense to have save_tracing_file_data() non static.

It can be logically from this patch, but read the change log and look
at the change. Remember, commits should do "one thing". If I do a git
blame, and come up with this patch for this update, would the change
log make sense to me? Probably not. If anything, the creation of the
"tracecmd_write_cmdlines()" looks like it should be a separate patch
(before this one), and include the static function change.

> > > @@ -782,34 +788,40 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
> > >       ret = read_header_files(handle);
> > >       if (ret < 0)
> > >               return -1;
> > > +     handle->file_state = TRACECMD_FILE_HEADERS;
> > > +     tep_set_long_size(handle->pevent, handle->long_size);  
> >
> > The moving of setting long size also looks to be unrelated to (or perhaps
> > it's just a dependency of) this patch. That change should also be in a
> > separate patch.  
> 
> It is related. This patch changes the behaviour of reading and

Related is fine, but is it part of the "do one thing" of a commit?

It looks like it can easily be broken out as its own stand alone patch,
and it changes the logic outside of what the change log is stating.

> parsing the trace.dat file headers in case of partially written file,
> the use case of listener and agent.  As the long size information
> is already available at that moment, when the
> TRACECMD_FILE_HEADERS state is reached, it should be applied.
> Otherwise it could be lost, in case some of the headers after that are
> still not present in the file - which may be a valid and expected situation.
> When the tracecmd_get_output_handle_fd() is used to read a partially
> written file, there is one important change - tracecmd_read_headers()
> is called, to get the state of that partial file. Without the above
> "set long size"
> change, the tep hanlder used in tracecmd_get_output_handle_fd() could be
> with invalid long size, even though the long size is in the file.

I'm saying, make this change a separate patch before this patch, and
state why it is being made. Again, I read the change log, and I don't
associate what is in there with this change.



> > > @@ -1048,10 +1097,17 @@ int tracecmd_write_options(struct tracecmd_output *handle)
> > >       unsigned short option;
> > >       unsigned short endian2;
> > >       unsigned int endian4;
> > > +     int ret;
> > >
> > >       /* If already written, ignore */
> > > -     if (handle->options_written)
> > > +     if (handle->file_state == TRACECMD_FILE_OPTIONS)
> > >               return 0;
> > > +     ret = check_out_state(handle, TRACECMD_FILE_OPTIONS);
> > > +     if (ret < 0) {  
> >
> > I wonder if we should keep the old logic, which using states is the
> > equivalent of:
> >
> >         if (handle->file_state >= TRACECMD_FILE_OPTIONS)
> >                 return 0;
> >
> > And not even bother with the check, as the old logic would not error nor
> > warn if this was called in a later state after options.  
> 
> We should not use the old logic here. This patch changes the way partially
> written trace.dat files are processed. Handlers to such files are created by
> tracecmd_get_output_handle_fd(), which now tracks the state of the partial
> file - what headers are already written. In the old logic, options_written is
> always false for partial files, even though the options could already be in
> the file. That just worked because tracecmd_write_options() is never called
> in such cases, where options are already in the file. But with the new logic,
> the state of the partial file reflects its content, this should be
> taken into account.

Hmm, have you tested all the trace-cmd commands (like split, restore,
etc) to make sure they still work? There might be some dependencies on
these, and those commands are critical, but rarely tested.

> > > index efd96d27..9396042d 100644
> > > --- a/tracecmd/trace-record.c
> > > +++ b/tracecmd/trace-record.c
> > > @@ -3770,7 +3770,7 @@ static void setup_agent(struct buffer_instance *instance,
> > >       network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
> > >                                                    listed_events);
> > >       add_options(network_handle, ctx);
> > > -     save_tracing_file_data(network_handle, "saved_cmdlines");
> > > +     tracecmd_write_cmdlines(network_handle);  
> >
> > Yeah, I think the above change should be a separate patch.  
> 
> I think it should be part of this patch, as using the new
> tracecmd_write_cmdlines() API is an important part of
> the file validation.

What you just said, is "this change is required for the file
validation", which is correct, but I don't see it as part of the
validation code. It's not validating anything. It's a needed change for
the validation, but not part of the validation. See what I'm trying to
say.

Every change should be associated with what is described in the change
log. If it is something that is needed to accomplish what is in the
change log, then it should be a separate patch ahead of this change.

I see three things being done in this patch. All to achieve a common
purpose, but still three changes.

1) The tracecmd_write_cmdlines() update
2) The moving of the tep_set_long_size()
3) The validation logic.

The three together accomplish the goal, but they are three different
steps that can be made.

In the kernel you will be asked to separate things like this out as
well.

-- Steve
