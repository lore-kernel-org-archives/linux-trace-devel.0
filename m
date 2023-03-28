Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711E8C76196
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 14:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjC1OaK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 10:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjC1OaK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 10:30:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57670198
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 07:30:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 07C6621A2E;
        Tue, 28 Mar 2023 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680013807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wvAO7+ShCyFeQ0Ah6egEm2ZHNVvUJKk9w81r/ArrYNc=;
        b=mJnC2v9c5MjpmkAfRkcwO13z9IbqMQqOpGLvD1jPRHxtJ1XXkjvY2TNHHcTzipzSNuhIwF
        /QHGrhDv9jcZcIIiP4+S7Z9IW+rgTg1eAmcA6iSNsH3wIP/zP4jxixi0xg1VLewoABzWhH
        +Hg8vzVtGxT9qOFbOZTeqieTbvPk+f0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680013807;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wvAO7+ShCyFeQ0Ah6egEm2ZHNVvUJKk9w81r/ArrYNc=;
        b=4iIlXwTKYeaAnBjOJ0ILSQzvX636K4uIUuKSlDLUVYOgsixzEqHftaGwwv9v9lrQal6riO
        0RHijQVQoiQJm1Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6408B1390D;
        Tue, 28 Mar 2023 14:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l0NIBe75ImRHeAAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 28 Mar 2023 14:30:06 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH trace-cmd] trace-cmd report: Ensure filter is applied to
 single input file
In-Reply-To: <20230327181103.3da07fa2@gandalf.local.home> (Steven Rostedt's
        message of "Mon, 27 Mar 2023 18:11:03 -0400")
Organization: SUSE
References: <20230317212430.12675-1-krisman@suse.de>
        <20230327181103.3da07fa2@gandalf.local.home>
Date:   Tue, 28 Mar 2023 11:30:03 -0300
Message-ID: <87h6u5x82c.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Fri, 17 Mar 2023 18:24:30 -0300
> Gabriel Krisman Bertazi <krisman@suse.de> wrote:
>
>> Since 955d05fc7aee ("trace-cmd report: Make filter arguments match their
>> files"), the -F filtering is silently ignored when a trace file is
>> provided with -i and the filter comes after -i .  The reason is that the
>> filter is now associated with input_files and not saved to the global
>> list only in this case, but process_filters still only checks the global
>> list when handles->input_file is not set.
>> 
>> Avoid this by checking last_input_file first, which always contains a
>> pointer to the correct filter in this case.
>> 
>> This was only lightly tested, using a single trace file.
>> 
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217038
>> Fixes: 955d05fc7aee ("trace-cmd report: Make filter arguments match their files")
>> Signed-off-by: Gabriel krisman Bertazi <krisman@suse.de>
>> ---
>>  tracecmd/trace-read.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
>> index 52ba818..dbbd124 100644
>> --- a/tracecmd/trace-read.c
>> +++ b/tracecmd/trace-read.c
>> @@ -567,11 +567,15 @@ static void process_filters(struct handle_list *handles)
>>  	struct tracecmd_filter *trace_filter;
>>  	struct filter_str *filter;
>>  	int filters = 0;
>> +	struct input_files *input_file = handles->input_file;
>
> BTW, please keep the "upside-down x-mas tree" formatting of the above.
>
> ie.

Hey Steve,

thanks for the review!

>
> static void process_filters(struct handle_list *handles)
> {
>         struct input_files *input_file = handles->input_file;
>         struct tracecmd_filter *trace_filter;
>         struct filter_str *filter;
>         int filters = 0;
>
>
>>  
>> -	make_pid_filter(handles->handle, handles->input_file);
>> +	if (!input_file)
>> +		input_file = last_input_file;
>>  
>> -	if (handles->input_file)
>> -		filter = handles->input_file->filter_str;
>> +	make_pid_filter(handles->handle, input_file);
>> +
>> +	if (input_file)
>> +		filter = input_file->filter_str;
>>  	else
>>  		filter = filter_strings;
>>  
>
> So I was playing with this, and I actually needed something else.
>
> If an -F comes before *any* file, I think it should be added to *all* files.
>
> That is:
>
>  -F sched_switch -i trace1.dat -i trace2.dat
>
> Should filter sched_switch for both trace1.dat and trace2.dat.
>
> I actually wanted this just a few minutes ago ;-)
>
> Can you do this, or would you want me to?

sure, i can do that.

Unless you are in a hurry, let me take a look later this week.

-- 
Gabriel Krisman Bertazi
