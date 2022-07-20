Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B15C43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jul 2022 14:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiGTOr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 10:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiGTOr0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 10:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409CB4E63C;
        Wed, 20 Jul 2022 07:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8C6CB81FB5;
        Wed, 20 Jul 2022 14:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C5DC3411E;
        Wed, 20 Jul 2022 14:47:20 +0000 (UTC)
Date:   Wed, 20 Jul 2022 10:47:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
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
        Tao Zhou <tao.zhou@linux.dev>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V6 01/16] rv: Add Runtime Verification (RV) interface
Message-ID: <20220720104718.59148968@gandalf.local.home>
In-Reply-To: <69bb4c369b4f6f12014eb9ca3c28b74e4378c007.1658244826.git.bristot@kernel.org>
References: <cover.1658244826.git.bristot@kernel.org>
        <69bb4c369b4f6f12014eb9ca3c28b74e4378c007.1658244826.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Jul 2022 19:27:06 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +/*
> + * Interface to read the enable/disable status of a monitor.
> + */
> +static ssize_t monitor_desc_read_data(struct file *filp, char __user *user_buf, size_t count,
> +				      loff_t *ppos)
> +{
> +	struct rv_monitor_def *mdef = filp->private_data;
> +	char buff[256];
> +
> +	memset(buff, 0, sizeof(buff));
> +
> +	mutex_lock(&rv_interface_lock);
> +	snprintf(buff, sizeof(buff), "%s\n", mdef->monitor->description);
> +	mutex_unlock(&rv_interface_lock);

What exactly is the mutex protecting here?

-- Steve

> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buff, strlen(buff) + 1);
> +}
> +
