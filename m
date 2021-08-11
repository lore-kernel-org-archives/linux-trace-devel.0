Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F34C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2020D60FC3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhHKPEK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 11:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232440AbhHKPEJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 11:04:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DFF60F55;
        Wed, 11 Aug 2021 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628694226;
        bh=3SyeoegT7NMt9d7RSU3GZgS9oF0SIeQGYOW5leKuaQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GpSupeFK+RqVnwzSldCsGXC5fG9dPNrZ2jY1VAN3XqcZBv+rJ6uPGqzWPi0EiuVi1
         kuSG6QgIOg9oDRb6fqL/jmRZOf9G5y5Tf0sHzWJ/3M6HSeQwgmP8vY/Ow+dqaClL8G
         YkwQ/bQGoXW2FiKKBj+hMasrNSsr4A+LfGNJ523bmrGDDkCseJTvVVcpYS+0SXJQ4k
         dY/zXL2bVBqYlEhKNTuBQMM6jKfuzQ/qVGlGqqwGHIBvXId/ic0KwQxtsAVIoXqLS5
         d91ZFVwvGLe/rUqBfnfONdYFMbSDrhcQJKV8S/NLXJsj+lNSh13XXjSxPVwrsPIP+c
         zSjdXknFyboqw==
Date:   Thu, 12 Aug 2021 00:03:43 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
In-Reply-To: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Aug 2021 17:14:33 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> 
> A new dynamic event is introduced: event probe. The event is attached
> to an existing tracepoint and uses its fields as arguments. The user
> can specify custom format string of the new event, select what tracepoint
> arguments will be printed and how to print them.
> An event probe is created by writing configuration string in
> 'dynamic_events' ftrace file:
>  e:GNAME/ENAME SYSTEM.EVENT [FETCHARGS]	- Set an event probe

Hmm, this inconsistency looks not good to me.

"GNAME/ENAME" "SYSTEM.EVENT"
 - GNAME is "group name" but SYSTEM is "system name" but both must point
   same idea.
 - Delimiter character is different.

Aren't these confusing users?

One idea is adding a patch for kprobe and uprobe events to accept new
delimiter '.'. This will give a consistency with hist triggers too.

Also, you can add a note about that the system and group is same
meaning in events.

>  -:GNAME/ENAME				- Delete an event probe
> 
> Where:
>  GNAME	- Group name, if omitted 'eprobes' is used.

If this is not mandatory, you should write it as 

e:[GNAME/]ENAME SYSTEM.EVENT [FETCHARGS]


>  ENAME	- Name of the new event in GNAME, mandatory.
>  SYSTEM	- Name of the system, where the tracepoint is defined, mandatory.
>  EVENT	- Name of the tracepoint event in SYSTEM, mandatory.
>  FETCHARGS - Arguments:
>   <name>=$<field>[:TYPE] - Fetch given filed of the tracepoint and print
> 			   it as given TYPE with given name. Supported
> 			   types are:
> 	                    (u8/u16/u32/u64/s8/s16/s32/s64), basic type
>         	            (x8/x16/x32/x64), hexadecimal types
> 			    "string", "ustring" and bitfield.
> 
> Example, attach an event probe on openat system call and print name of the
> file that will be opened:
>  echo "e:esys/eopen syscalls.sys_enter_openat file=\$filename:string" >> dynamic_events
> A new dynamic event is created in events/esys/eopen/ directory. It
> can be deleted with:
>  echo "-:esys/eopen" >> dynamic_events
> 
> Filters, triggers and histograms can be attached to the new event, it can
> be matched in synthetic events. There is one limitation - no synthetic
> events can be attached to an event probe.

I'm not sure what the "no synthetic events can be attached to an event probe"
means.
Can you show an example command what this means?

> 
> Co-developed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> Subject of the patch is still related to kprobe, though the design no
> more depends on kprobe. I did not change it for consistency with the
> first patch version. 

OK, thanks for moving onto the dynevent. Let me check the code in another
mail.
Anyway, I think this is good starting point. 

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
