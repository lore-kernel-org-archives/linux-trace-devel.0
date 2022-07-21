Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3D0C43334
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jul 2022 14:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiGUOzP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jul 2022 10:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiGUOzH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jul 2022 10:55:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078BB2ED41;
        Thu, 21 Jul 2022 07:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A53B1B82555;
        Thu, 21 Jul 2022 14:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A4CC3411E;
        Thu, 21 Jul 2022 14:54:58 +0000 (UTC)
Date:   Thu, 21 Jul 2022 10:54:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tao Zhou <tao.zhou@linux.dev>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V6 01/16] rv: Add Runtime Verification (RV) interface
Message-ID: <20220721105456.1a6a8fb7@gandalf.local.home>
In-Reply-To: <Ytlk4ePA+TpGItJ6@geo.homenetwork>
References: <cover.1658244826.git.bristot@kernel.org>
        <69bb4c369b4f6f12014eb9ca3c28b74e4378c007.1658244826.git.bristot@kernel.org>
        <Ytlk4ePA+TpGItJ6@geo.homenetwork>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Jul 2022 22:38:25 +0800
Tao Zhou <tao.zhou@linux.dev> wrote:

> > +static int enable_monitor(struct rv_monitor_def *mdef)
> > +{
> > +	int retval;
> > +
> > +	if (!mdef->monitor->enabled) {
> > +		retval = mdef->monitor->enable();
> > +		if (retval)
> > +			return retval;
> > +	}
> > +
> > +	mdef->monitor->enabled = 1;  
> 
> This should be placed at the end of the last if block. Otherwise
> another assignment may be duplicated because it is already 1 now.
> no?(not sure how compiler treat this..)

It really doesn't matter, it will just sent enabled to one even though it's
already one.

You could simplify this to be:

static int enable_monitor(struct rv_monitor_def *mdef)
{
	int retval;

	if (mdef->monitor->enabled)
		return 0;

	retval = mdef->monitor->enable();

	if (!retval)
		mdef->monitor->enabled = 1;

	return retval;
}

-- Steve

