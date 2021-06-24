Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B1C48BC2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 01:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A7660FEB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 01:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFXBIm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 21:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhFXBIl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 21:08:41 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD84A61375;
        Thu, 24 Jun 2021 01:06:22 +0000 (UTC)
Date:   Wed, 23 Jun 2021 21:06:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Claire Jensen <cjense@google.com>
Cc:     eranian@google.com, irogers@google.com, tz.stoyanov@gmail.com,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libtraceevent: Add eof checks.
Message-ID: <20210623210621.3b35e0d4@rorschach.local.home>
In-Reply-To: <20210617155828.4e9c7f45@gandalf.local.home>
References: <20210617194326.2107129-1-cjense@google.com>
        <20210617155828.4e9c7f45@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Jun 2021 15:58:28 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 17 Jun 2021 19:43:25 +0000
> Claire Jensen <cjense@google.com> wrote:
> 
> Hi Claire,
> 
> Thanks for sending the patches, I'll try to get some time to look at them
> (note, that I have a lot of other duties that I need to finish before I can
> get to this).
> 
> > Added checking for __read_char and peek_char to make sure value is not at end
> > of file.
> > 
> > This issue was found while fuzz testing. One of the test cases created an infinite loop because __read_token had reached end of file. Checking was added to all cases where this may occur.  
> 
> You don't need to fix this now, but for future reference, we follow the
> Linux guidelines on submitting patches which includes having line breaks at
> 74 (although I use 76) bytes, for the change log.
> 
> This makes the change logs easier to read.
> 

I made the mistake of adding this patch and pushing it to a new release
without running my test suite against it. It ended up breaking the parsing.

When running with --debug -N, I get:

  [ftrace:branch] unexpected type 1
  [sched:sched_switch] unknown op ''
  [irq:irq_handler_exit] unexpected type 1
  [timer:timer_start] unknown op ''
  [kvm:vcpu_match_mmio] unexpected type 1
  [kvm:kvm_wait_lapic_expire] unknown op ''
  [kvm:kvm_vcpu_wakeup] unexpected type 1
  [kvm:kvm_userspace_exit] unknown op ''
  [kvm:kvm_pv_tlb_flush] unexpected type 1
  [kvm:kvm_ple_window_update] unknown op ''
  [kvm:kvm_pio] unknown op ''
  [kvm:kvm_pic_set_irq] unknown op ''
  [kvm:kvm_nested_vmrun] unexpected type 1
  [kvm:kvm_nested_vmexit_inject] unknown op ''
  Error: expected type 5 but read 0
  [kvm:kvm_nested_vmexit] unknown op ''
  Error: expected type 5 but read 0
  [kvm:kvm_nested_vmenter_failed] bad op token 
  [kvm:kvm_msr] unexpected type 1
  [kvm:kvm_msi_set_irq] unknown op ''
  unknown op ''
  [kvm:kvm_ioapic_set_irq] unknown op ''
  Error: expected type 5 but read 0
  unknown op ''
  [kvm:kvm_ioapic_delayed_eoi_inj] unknown op ''
  Error: expected type 5 but read 0
  [kvm:kvm_exit] unknown op ''
  Error: expected type 5 but read 0
  [kvm:kvm_emulate_insn] unknown op ''
  Error: expected type 5 but read 0
  [kvm:kvm_cpuid] unexpected type 1
  unknown op ''
  [kvm:kvm_apic_ipi] unknown op ''
  Error: expected type 5 but read 0
  unknown op ''
  [kvm:kvm_apic_accept_irq] unknown op ''
  Error: expected type 5 but read 0
  [kvm:kvm_age_page] unexpected type 1

with the patch, and no errors without it.

I have to revert this patch and push a new version out.

-- Steve
