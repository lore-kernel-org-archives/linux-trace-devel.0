Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A50C32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 12:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiI1MP5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 08:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiI1MP4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 08:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7304C7E004
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 05:15:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E88ED61E73
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 12:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083D2C433C1;
        Wed, 28 Sep 2022 12:15:53 +0000 (UTC)
Date:   Wed, 28 Sep 2022 08:17:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Junichi Uekawa (=?UTF-8?B?5LiK5bed57SU5LiA?=)" <uekawa@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: trace-cmd report: Add callback for kvm plugin to show guest
 functions
Message-ID: <20220928081704.74d22a2d@gandalf.local.home>
In-Reply-To: <CADgJSGEoELCWYYxsRJaMK9egCUhbRV7QWEqTga71tAC-GR8qeA@mail.gmail.com>
References: <20220921202642.44fec719@gandalf.local.home>
        <CADgJSGEoELCWYYxsRJaMK9egCUhbRV7QWEqTga71tAC-GR8qeA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Sep 2022 09:24:14 +0900
Junichi Uekawa (上川純一) <uekawa@google.com> wrote:

> +
> +
> +const char *tep_plugin_kvm_get_func(struct tep_event *event,
> +                                   struct tep_record *record,
> +                                   unsigned long long *val)
> +{
> 
> I think this could be implemented in a .so plugin that is dlopen()'d which might be more intuitive (along with the others).
> I think using dlopen RTLD_GLOBAL will use the symbols instead of the weak symbols (but I need to check if that was the actual behavior).

So we should have a dlopen on an .so from this .so that is dlopen()ed?

The issue here is that libtraceevent has several .so plugins loaded with
dlopen(). One of them is the plugin_kvm.so, which needs a way to translate
the rip that the host receives with the function it maps to in the guest.
The issue is that the libtraceevent only handles one set of tracing data,
and that's for just the host. Now because plugin_kvm.so is a plugin, it
only interacts with libtraceevent.

Now we could add a call to libtraceeveent that is
"tep_load_guest_mappings()" but then we need to make it so that it can load
several guest mappings, and the place in the plugin_kvm.so will need to
also know what guest it is for.

In which case I feel it is losing the scope of what libtraceevent is for
(just parsing of the event's raw data). Which is why I added this hack.

Or maybe I misunderstood what you were suggesting.

-- Steve


>  
> +       struct tep_handle *tep;
> +       struct kvm_cpu_map *map;
> +       struct kvm_cpu_map key;
> +       unsigned long long rip = *val;
> +       const char *func;
> +       int pid;
