Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B268C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 23:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1B18214D8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 23:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uq5DG41h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfCKX6m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 19:58:42 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38755 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfCKX6m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 19:58:42 -0400
Received: by mail-ua1-f66.google.com with SMTP id d4so198180uap.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 16:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N20KT5RcXIKPLrLophveDXK6Y0mLDSNidvB525qrrR4=;
        b=Uq5DG41hDYZnL4k0WSqLJZ+5EwzG2Ir9JXnjcdwhafRkUqyfhN2HeeX90hvLnK7xzA
         q43QEN82NFlw6uwcRCPRQDzVINJhOCRHd0TBwJV6WjA2VWLKMP9BE7FwG4z3nIMHwhTW
         6n1aHf8JlxocAOkkfWxkMSWccPOu2qRVcFVcZwNf8wdqzuctk7boRAZokzqZU5diIwV+
         L53I7/zvvb7OWkI6PyOIEA0WvGZ0qUSgleYnPXmIlIY/Ew2AYYKmNwbt1ttVXC6THTJh
         DFBYbxz6pPBhNfCFs7AIyHQkMDieigJZ5xCeZtvZf0/rPCp/8uy8vPJbF1l4P0Hbp26j
         jw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N20KT5RcXIKPLrLophveDXK6Y0mLDSNidvB525qrrR4=;
        b=RaaAzbWuzh5pVgQTYpwT14EzauHZs0aow3lpXCmWBkQjNL5ljlmF3K3dwKzqSo/7xh
         fTGUNfJbSkJrTH01//p0OwXCGJGM+NvxE/SQHNekm0rUfu9T/vYcQQiD8TxhGF695y21
         7zZychuaV1M9upJjETjAMIjJpI71W5jKbnpGKg8/kHYsx54EUJskXmX3GbqAaryhZJUe
         3tM05HooEs13uO+NNlBjxW86o1Yt3K2asH9uEcDwuNF+uPOCqXJN9WEVgDqU8m00Mu6s
         GYnfK4DYwo312VCN8WVcbzAtidOu5tWnZPO0S3+kQilbEgANuh4Pe3i5ap+mtMCD29gm
         oNGA==
X-Gm-Message-State: APjAAAWJGXsSDlTr/3x0933uhwrlGAe6Z1XXsxNNEKzpXcM9UDZClqS7
        RiHKIunzVypw2hK8iB6QTyo6d0NqrfLwOEvbz0tMQg==
X-Google-Smtp-Source: APXvYqwxdOTsTmN5RIMe8AVgPVdKtkhXD3+gwq0S4Sf7OkgKZaRvyUvN4jKKDGXJkoRw0KfZA20o25K8rfMjVxdaGYE=
X-Received: by 2002:ab0:2789:: with SMTP id t9mr18483371uap.100.1552348720797;
 Mon, 11 Mar 2019 16:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com> <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com> <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com> <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com> <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
 <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com> <20190311193612.4f09bf11@oasis.local.home>
In-Reply-To: <20190311193612.4f09bf11@oasis.local.home>
From:   Daniel Colascione <dancol@google.com>
Date:   Mon, 11 Mar 2019 16:58:28 -0700
Message-ID: <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Karim Yaghmour <karim.yaghmour@opersys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 4:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 9 Mar 2019 16:44:31 -0500
> Karim Yaghmour <karim.yaghmour@opersys.com> wrote:
>
>
> > Sorry, I should've been clearer. I'm including eBPF/BCC into the
> > "user-space tools" here. That was in fact my prime motivation in
> > encouraging Joel at the last LPC to look at this. I've been integrating
> > the teaching of eBPF into my AOSP debugging and performance analysis
> > class (see CC courseware here:
> > http://www.opersys.com/training/android-debug-and-performance), and it
> > was pretty messy trying to show people how to benefit from such tools
> > under Android. Joel's present set of patches would obviate this problem.
>
> I've been reading this thread and staying out for the most part. But I
> was thinking about how I could use kernel headers for things like
> kprobes, and I want to mention the pony that I would like to have :-)
>
> Are headers really needed, and more importantly, are they enough? What
> if userspace is 32bit and the kernel is 64bit. Can ebpf scripts handle
> that?

Why would eBPF care about the bit width of userspace? I've thought a
lot about inspecting user state from the kernel and have some weird
ideas in that area (e.g., why not register eBPF programs to unwind
user stacks?) --- but I think that Joel's work is independent of all
that. I'm curious what you think we can do about userspace. I wish we
could just compile the world with frame pointers, but we can't.

> What I would love, is a table that has all structures and their fields
> with information about their types, size and signed types. Like the
> format fields in the events directory. This way ebpf (and kprobes,
> internally in the kernel) could access this table and be able to know
> what the data structures of the kernel is).

Think of the headers as encoding this information and more and the C
compiler as a magical decoder ring. :-) I totally get the desire for a
metadata format a little less messy than C code, but as a practical
matter, a rich C-compilation pipeline already exists, and the
debuginfo you're proposing doesn't, except in the form of DWARF, which
I think would be even more controversial to embed in the kernel memory
image than headers are. A header blob provides a strict superset of
the information your scheme provides.
