Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8664DC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 13:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53274218A1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 13:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552655657;
	bh=IEpUyL36q8/726NLraqLaGuCSWvp+z1d0IVNkmrGaZc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=RmDf0OM4Bvv++WeS/G6QPIjKPg4mSXflC7+gqaEEKNKtu/CfpZkrpXNADDF8BMO5N
	 4fRhWwT8nGB20Bq9OmuaMGrlgIIa6ovuYvM3acgPZAfg97qhGc7WZUxdbGvcSviS9i
	 fkbB8FbIEIkwm0AZjrAJaU2W2N74olR+yFkhpiTQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbfCONOR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 09:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfCONOQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 09:14:16 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DD021871;
        Fri, 15 Mar 2019 13:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552655656;
        bh=IEpUyL36q8/726NLraqLaGuCSWvp+z1d0IVNkmrGaZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JD/Y36s/ANTZMHwjoVQs98Vc/TdnjKZpxOrd3o8Q5CWbWoEO2OrnHTYQNWf61qD70
         QGkzLqvrc9wQunN+3VCCesWkBmuthUsgfLPj2uR4SvrSk38oQPGArH4KmmwgVYePyi
         bk3S668CcIIgN1QzQLPPn/u+ZkKOY+u2e2b3YWAU=
Date:   Fri, 15 Mar 2019 22:14:07 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Colascione <dancol@google.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-Id: <20190315221407.790154f634fc5fc084d7bf15@kernel.org>
In-Reply-To: <20190314122748.GA101545@google.com>
References: <20190309121141.GA30173@kroah.com>
        <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
        <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
        <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
        <20190311193612.4f09bf11@oasis.local.home>
        <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
        <20190312003912.GA170478@google.com>
        <20190311212823.60684182@oasis.local.home>
        <CAJWu+oqsD_wHGWfzj6POFowiY2qcu04auVzkA6Lu9R+LR4gkrQ@mail.gmail.com>
        <20190313101843.800dd8d6a9babb635580ebdc@kernel.org>
        <20190314122748.GA101545@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Mar 2019 08:27:48 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> > But the eBPF is based on kprobe-events. What kind of usage would you
> > expected? (with macros??)
> 
> eBPF C programs are compiled with kernel headers. They can execute inline
> functions or refer to macros in the kernel headers. They are similar to
> kernel modules where you build a C program that then later is executed in
> kernel context. It goes through the whole compiler pipeline. This is slightly
> different usage from pure kprobe-events.  Also eBPF kprobe programs need
> LINUX_VERSION_CODE (or similarly named) macro which it provides to the bpf(2)
> syscall when loading kprobe programs. This is because eBPF implementation in
> the kernel checks if the eBPF programs that use kprobes are being loaded
> against the right kernel.

Ah, I got it. It's similar to SystemTap. :)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
