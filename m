Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C5CC4741F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EDC20759
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgKEOBW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:01:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgKEOBV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:01:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C010720678;
        Thu,  5 Nov 2020 14:01:20 +0000 (UTC)
Date:   Thu, 5 Nov 2020 09:01:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/6] libtracefs: Combine allocate and create APIs into
 one
Message-ID: <20201105090118.6491aa9a@gandalf.local.home>
In-Reply-To: <20201105093354.532742-5-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
        <20201105093354.532742-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Tzvetomir,


On Thu,  5 Nov 2020 11:33:52 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -59,24 +59,38 @@ void tracefs_instance_free(struct tracefs_instance *instance)
>  
>  /**
>   * tracefs_instance_create - Create a new ftrace instance
> - * @instance: Pointer to the instance to be created
> + * @name: Name of the instance to be created
> + * @instance: Return, pointer to a newly allocated instance
>   *
>   * Returns 1 if the instance already exist, 0 if the instance
> - * is created successful or -1 in case of an error
> + * is created successful or -1 in case of an error.
> + * If 1 or 0 is returned, @instance points to anewly allocated instance
> + * which must be freed by tracefs_instance_free()
>   */
> -int tracefs_instance_create(struct tracefs_instance *instance)
> +int tracefs_instance_create(const char *name, struct tracefs_instance **instance)

I think it makes more sense if we just return the allocated instance.
The return would be the allocated instance or NULL on failure.

-- Steve

