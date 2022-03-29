Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7721EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Mar 2022 16:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbiC2Q7J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 12:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiC2Q7I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 12:59:08 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76BEAB0D13;
        Tue, 29 Mar 2022 09:57:25 -0700 (PDT)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id D622820DECF5;
        Tue, 29 Mar 2022 09:57:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D622820DECF5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648573045;
        bh=y4az3WkefbkCxNOR94uEneUMzG1hS7Ex1VtRu+4P1Bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IdcQGez5VpXMC13T34f3NRA32xpcJEd4uifF7Z6OeMFNtGAKR0TqJDL1H9QEkvIOs
         U+6EQhI2kt56AE62BCRK3yTBQzi0laG/ssqeocAEr+SShu8W7KmUs9driHbH6y3jUh
         fVXZhAf2HG3/ivXbo6dGbtMKMQK14LavBKD9/4To=
Date:   Tue, 29 Mar 2022 09:57:18 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Beau Belgrave <beaub@microsoft.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: Comments on new user events ABI
Message-ID: <20220329165718.GA10381@kbox>
References: <2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com>
 <20220329002935.2869-1-beaub@linux.microsoft.com>
 <1014535694.197402.1648570634323.JavaMail.zimbra@efficios.com>
 <CAADnVQK=GCuhTHz=iwv0r7Y37gYvt_UBzkfFJmNT+uR0z+7Myw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQK=GCuhTHz=iwv0r7Y37gYvt_UBzkfFJmNT+uR0z+7Myw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 29, 2022 at 09:25:52AM -0700, Alexei Starovoitov wrote:
> On Tue, Mar 29, 2022 at 9:17 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > >
> > >> include/uapi/linux/user_events.h:
> > >>
> > >> struct user_bpf_iter {
> > >>
> > >>         /* Offset of the data within the first iovec */
> > >>         __u32 iov_offset;
> > >>
> > >>         /* Number of iovec structures */
> > >>         __u32 nr_segs;
> > >>
> > >>         /* Pointer to iovec structures */
> > >>         const struct iovec *iov;
> > >>
> > >>                            ^ a pointer in a uapi header is usually a no-go. This should be a u64.
> > >> };
> > >>
> > >> include/uapi/linux/user_events.h:
> > >>
> > >> struct user_bpf_context {
> > >>
> > >>         /* Data type being passed (see union below) */
> > >>         __u32 data_type;
> > >>
> > >>         /* Length of the data */
> > >>         __u32 data_len;
> > >>
> > >>         /* Pointer to data, varies by data type */
> > >>         union {
> > >>                 /* Kernel data (data_type == USER_BPF_DATA_KERNEL) */
> > >>                 void *kdata;
> > >>
> > >>                 /* User data (data_type == USER_BPF_DATA_USER) */
> > >>                 void *udata;
> > >>
> > >>                 /* Direct iovec (data_type == USER_BPF_DATA_ITER) */
> > >>                 struct user_bpf_iter *iter;
> > >>
> > >>                                ^ likewise for the 3 pointers above. Should be u64 in uapi headers.
> > >>         };
> > >> };
> > >>
> > >
> > > The bpf structs are only used within a BPF program. At that point the pointer
> > > sizes should all align, right?
> >
> > I must admit I do not know enough about the eBPF uapi practices to answer this.
> > [CCing Alexei on this]
> 
> Mathieu,
> 
> Thanks for flagging.
> 
> Whoever added this user_bpf* stuff please remove it immediately.
> It was never reviewed by bpf maintainers.
> 
> It's a hard Nack to add a bpf interface to user_events.

Sorry about that, I'm sending a patch to remove this.

I'll have another patch to add it back in out to bpf and trace-devel for
review.

Thanks,
-Beau
