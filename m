Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A619EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 19:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiGKTRD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 15:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiGKTRA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 15:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7D86F7C0
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 12:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CE0EB80EC2
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 19:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3499C34115;
        Mon, 11 Jul 2022 19:16:56 +0000 (UTC)
Date:   Mon, 11 Jul 2022 15:16:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vineeth Pillai <vineethrp@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
Message-ID: <20220711151655.5a4f4cc0@gandalf.local.home>
In-Reply-To: <20220504010242.1388192-1-vineethrp@google.com>
References: <20220504010242.1388192-1-vineethrp@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  4 May 2022 01:02:42 +0000
Vineeth Pillai <vineethrp@google.com> wrote:

> The current detection of vcpu pid is based on the assumption that vcpuid
> is monotonically increasing starting from 0 to max_cpus - 1. But the
> crosvm uses the apic id as the vcpuid if topology is exposed to the
> guest. And apicid can be non-contiguous.
> 
> This patch gets the max apicid from guest and then uses it to detect the
> vcpu pids. Even this approach is not fool proof an it assumes that
> apicid monotonically increases. If we encounter a scenario where it is
> not the case, we might need to implement a mechanism to get a map of
> cpuid to vcpu from the guest and then use that to detect the pid.
> 
> Signed-off-by: Vineeth Pillai <vineethrp@google.com>

If you haven't noticed I have patches that are a workaround that fixes this
issue if the conditions are "right". (I Cc'd you) [1]

The work around is to not depend on the number in debugfs/kvm/vcpuX to
match the CPU of the guest, but instead to match the ordering of the CPUs
of the guest. It also requires that the guest's CPUs are consecutive and
non sparse. That is, if you have vcpu0, vcpu1, vcpu8 and vcpu9 on the
host, then the guest needs to have CPU 0-3 with the mapping of:

 vcpu0 -> CPU 0
 vcpu1 -> CPU 1
 vcpu8 -> CPU 2
 vcpu9 -> CPU 3

and then it works. Of course if this is not true, then it breaks again and
will require some more communication between the host and the guest.

[1] https://lore.kernel.org/all/20220708014244.677826-1-rostedt@goodmis.org/
