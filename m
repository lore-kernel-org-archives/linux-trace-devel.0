Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A21C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 11:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0293D60F91
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 11:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhHLLQ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 07:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhHLLQ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 07:16:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E08866103A;
        Thu, 12 Aug 2021 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628766962;
        bh=cCVIUQ7Xk/SQ17zPIQDuEBSetuylwimgtn2vHvloNHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BAs+F1H7AvfbtgGUT4jp53i50YkiLcCbnJFvDl2bDAxrtZrkVIHhEpJvYP+sZeask
         kjELib1IsxOgIu6ivL/jRwaO2x5pD5pfWMj5SXfMaLjGLTGmrfHN5UnVMH3Pq/yWZm
         CIkd18SzcyOpfZnSvyCi8Emeui3diQ2bo1JTmoX0yq0dGPl/4A47QmdNgB4sSpeCK7
         Cm19dUuWBPovHA58hya7fSAn7a3zEohE2k+I6Sr+xWgCa82jaXSUh6+fLVp5or0yq+
         vLlYJZgr7a+ONg11RUXgLtEj+4WMlaxjS2zlm/ycie9n5Zaf/nYWlYif/dpv0pKbNT
         dUg0YV72ZhD6Q==
Date:   Thu, 12 Aug 2021 20:15:59 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210812201559.31f5e520923d768049c8906d@kernel.org>
In-Reply-To: <20210812000225.68d72f4a@rorschach.local.home>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
        <20210811112249.555463f2@oasis.local.home>
        <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
        <20210812000225.68d72f4a@rorschach.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 00:02:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 12 Aug 2021 10:27:35 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > I like to prohibit latter one. It is my feeling, but I think it is
> > natural that the eprobe is only for the static events, and I also think
> > dereferencing a pointer-type field in raw-event is more reliable than
> > dereferencing a digit value passed to the synthetic event.
> 
> Although I believe we need to attach eprobes to synthetic events, for
> the reasons I stated in my previous email. I'm perfectly happy to
> forbid them from attaching to kprobe or uprobe events. Because,
> honestly, eprobes do not give you anything that a kprobe nor uprobe can
> give you.

Agreed. It is meaningless to put eprobes on kprobes or uprobes.

Thank you,

> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
