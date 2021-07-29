Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E4CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC7360F01
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhG2TxB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 15:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhG2TxA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 15:53:00 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE5C60EFF;
        Thu, 29 Jul 2021 19:52:56 +0000 (UTC)
Date:   Thu, 29 Jul 2021 15:52:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 05/87] trace-cmd library: Fix possible memory
 corruption on processing a trace buffer
Message-ID: <20210729155250.24b5a443@oasis.local.home>
In-Reply-To: <20210729050959.12263-6-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:08:37 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added a safety check to ensure requested buffer index is valid.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index af11cbc6..787d6825 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -3946,13 +3946,14 @@ struct tracecmd_input *
>  tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
>  {
>  	struct tracecmd_input *new_handle;
> -	struct input_buffer_instance *buffer = &handle->buffers[indx];
> +	struct input_buffer_instance *buffer;
>  	size_t offset;
>  	ssize_t ret;
>  
>  	if (indx >= handle->nr_buffers)
>  		return NULL;
>  
> +	buffer = &handle->buffers[indx];

This part is unneeded.

You could have indx = 10000000000000, and it wont bug.

Try it!

$ echo '
#include <stdio.h>
struct my_buffer {
        int     buf;
};

struct my_handle {
        struct my_buffer *buffers;
};

int main() {
        int indx = 10000000;
        struct my_buffer buf;
        struct my_handle hand = { .buffers = &buf };
        struct my_handle *phand = &hand;
        struct my_buffer *pbuf = &phand->buffers[indx];

        printf("pbuf = %p\n", pbuf);
        return 0;
}' > /tmp/blah

$ gcc -o /tmp/blah /tmp/blah.c -g -Wall
$ /tmp/blah
pbuf = 0x7ffe867b9b74

The reason is because we are getting the address of the indexed
location, and we are not dereferencing it. Thus, it is perfectly safe
to keep the code as is. There was no safety check added. Please remove
this hunk.

/me is reminded of the first X-Men movie, where Rogue warned Wolverine
about the guy that was about to stab him. Afterward, she said, "I saved
your life", and Wolverine replied "No you didn't.". As Rogue didn't
know that Wolverine had super healing powers where the knife would not
kill him. ;-)

-- Steve

