Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B541C4338F
	for <linux-trace-devel@archiver.kernel.org>; Sat,  7 Aug 2021 01:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D083E61040
	for <linux-trace-devel@archiver.kernel.org>; Sat,  7 Aug 2021 01:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhHGB3G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 21:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhHGB3F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 21:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4227361186;
        Sat,  7 Aug 2021 01:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628299729;
        bh=67fdUmsDpqiDWAVFysFaEwOcK+gqxoJ0H+s8OGBnMvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oN9yoaYTOyvq7T86m49nv27DA02J7u5Ne5SBA8k2xMEIHKb/cCiLvQCwfk+lrpmgC
         qQdAcVZeQ99nxLZvLOI/dG5rdgDnIBUFMWCY0OhKDefmzPbL5zuWjdGbd+kgSxOuOQ
         cW6IdzzC0BXhCQD/M9HnTyUadVbCuEQthTZYnE2bTHVHxW4B3eR2z9743auZSFshBv
         7N394R4yO5AaLLdg9gwG4hcSv7uQXiySAvN5G18gtTNTZ9gsGOBrz5BIFajNg6FDNO
         8JxQUvF4uZUcw/Sam3XVfMlY27le6F0o0pw9ZJhrEkYQML+N/XbkKHnQWyUqq84KCO
         ldqleTtypCtGw==
Date:   Sat, 7 Aug 2021 10:28:46 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        mhiramat@kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [RFC] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210807102846.4d4f88b157deb26b9345fab5@kernel.org>
In-Reply-To: <20210806174928.847848-1-tz.stoyanov@gmail.com>
References: <20210806174928.847848-1-tz.stoyanov@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

On Fri,  6 Aug 2021 20:49:28 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> 
> The /sys/kernel/debug/tracing/kprobe_events interface is extended with a
> new type of user defined dynamic event, that is attached to an existing
> tracepoint. The user can specify custom format string of the new event,
> select what tracepoint arguments will be printed and how to print them.
> 
> The format is similar to the existing kprobe_events interface:
>  e:GNAME/ENAME SYSTEM/EVENT [FETCHARGS]	- Set an event probe
>  -e:GNAME/ENAME				- Delete an event probe
> 
> Where:
>  GNAME	- Group name, mandatory
>  ENAME	- Name of the new event in GNAME, mandatory
>  SYSTEM	- Name of the system, where the tracepoint is defined, mandatory
>  EVENT	- Name of the tracepoint event in SYSTEM, mandatory
>  FETCHARGS - Arguments:
>   <name>=$<field>[:TYPE] - Fetch given filed of the tracepoint and print it as
> 		    given TYPE with given name. Supported types are
>                     (u8/u16/u32/u64/s8/s16/s32/s64), basic type
>                     (x8/x16/x32/x64), hexadecimal types
> 		    "string", "ustring" and bitfield.
> 
> Example, attach event probe on openat system call and print name of the
> file that will be opened:
>  echo "e:esys/eopen syscalls.sys_enter_openat file=\$filename:string" >> kprobe_events
> A new dynamic event is created in events/esys/eopen/ directory. It
> can be deleted with:
>  echo "-e:esys/eopen" >> kprobe_events

Hmm, sorry, I rather like to use synthetic event with trigger action,
since this is not a kprobe.
Can you change your idea to use trigger action with synthetic event?

For example, if we have a "trace" action in the trigger action,

echo "eopen char filename[]" >> synthetic_events
echo "trace:eopen,filename.ustring" >> events/syscalls/sys_enter_openat/trigger

A new action is,
  trace:SYNTH_EVENT,PARAM(s) [if FILTER]
and
  .ustring/.string modifier for the PARAMS.

I think this matches the current dynamic event model, and can extend
programmability of the ftrace, and keeps dynamic events simple.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
