Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D90BCCA47E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiFHPVa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343549AbiFHPUg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 11:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C601C13F412
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 08:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7835B827E7
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 15:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365E4C34116;
        Wed,  8 Jun 2022 15:17:47 +0000 (UTC)
Date:   Wed, 8 Jun 2022 11:17:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>
Subject: Re: [PATCH] libtraceevent: Reset field properly in
 event_read_fields()
Message-ID: <20220608111745.3462e3d6@gandalf.local.home>
In-Reply-To: <20220607045925.814164-1-namhyung@kernel.org>
References: <20220607045925.814164-1-namhyung@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Jun 2022 21:59:25 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> The field pointer is allocated and added to the fields list in a
> loop.  But it might refer the previous one if it fails to parse before
> allocating a new one.
> 
> In that case, it would free the previous field but didn't update the
> link of the list for the one before it.  Moreover, it doesn't need to
> free the previous one as it finished ok.  Let's reset the field
> pointer at the end of each iteration so that it cannot see the
> previous one.
> 
> This was found by a fuzz test with an event having only one field.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Applied. Thanks Namhyung!

-- Steve


> ---
>  src/event-parse.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 8f4fb59..1ba2a78 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -1902,6 +1902,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
>  
>  		*fields = field;
>  		fields = &field->next;
> +		field = NULL;
>  
>  	} while (1);
>  

