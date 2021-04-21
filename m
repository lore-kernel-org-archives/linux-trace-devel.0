Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BF4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 03:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58372611C9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 03:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhDUD1t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 23:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhDUD1t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 23:27:49 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C40160200;
        Wed, 21 Apr 2021 03:27:16 +0000 (UTC)
Date:   Tue, 20 Apr 2021 23:27:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent and copy in linux/tools
Message-ID: <20210420232714.43925af0@oasis.local.home>
In-Reply-To: <CAP-5=fWSDxOxBsoK8koaNbJwTVgjJwzoVe1jYuoX-Vhvteqcqg@mail.gmail.com>
References: <CAP-5=fWSDxOxBsoK8koaNbJwTVgjJwzoVe1jYuoX-Vhvteqcqg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Apr 2021 20:09:25 -0700
Ian Rogers <irogers@google.com> wrote:

> Hi,
> 
> libtracefs [1] has a dependency on tep_vwarning which is declared in
> libtraceevent [2]. The libtraceevent in linux/tools lacks this [3] and
> so trace-cmd, that requires libtracefs, can only be built with the
> separate libtraceevent. I'm trying to avoid having two libtraceevent.
> Should the copy in linux/tools be updated or should I not be using
> that any more?

Yes, the libtraceevent in the linux kernel is deprecated, and once
libtraceveent is available in all major distros (from the separate
library), we will be removing it from the kernel and having perf use
the library version.

-- Steve
