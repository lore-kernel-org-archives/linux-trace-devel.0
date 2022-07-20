Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A98AC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jul 2022 16:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiGTQlm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiGTQlm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 12:41:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD424F670;
        Wed, 20 Jul 2022 09:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACDF9CE218F;
        Wed, 20 Jul 2022 16:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5E5C3411E;
        Wed, 20 Jul 2022 16:41:35 +0000 (UTC)
Date:   Wed, 20 Jul 2022 12:41:33 -0400
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
Subject: Re: [PATCH V6 02/16] rv: Add runtime reactors interface
Message-ID: <20220720124133.3cdd2c44@gandalf.local.home>
In-Reply-To: <4b5f93e3186b067073c1692d4c2b50d0b42101d5.1658244826.git.bristot@kernel.org>
References: <cover.1658244826.git.bristot@kernel.org>
        <4b5f93e3186b067073c1692d4c2b50d0b42101d5.1658244826.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Jul 2022 19:27:07 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +/*
> + * reacting_on interface.
> + */
> +static ssize_t reacting_on_read_data(struct file *filp,
> +				     char __user *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	char *buff;
> +
> +	mutex_lock(&rv_interface_lock);
> +	buff = reacting_on ? "1\n" : "0\n";
> +	mutex_unlock(&rv_interface_lock);

Again, no need for the locks, but perhaps just to keep things sane:

	buf = READ_ONCE(reacting_on) ? "1\n" : "0\n";

-- Steve

> +
> +	return simple_read_from_buffer(user_buf, count, ppos, buff, strlen(buff)+1);
> +}
> +
