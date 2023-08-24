Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF592C3DA6F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 21:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243537AbjHXVYH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 17:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbjHXVXp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 17:23:45 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F461FCA
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 14:23:40 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-792707f78b5so11078439f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 14:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692912220; x=1693517020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CLlmHuBmXQbShq6LQ0rDjiyEZzFGxBpm6sWhP8DUGrU=;
        b=cicWhdtcQrX7yN7kAF2BK2OwwNnyCa4LqFhuKCDfjfqM//4N6rj72KAL7XBL5XMEYm
         ANowb+YIJ13n6Ef5CWz3KIlz8rYfioWuaD5ClB7XlNyy+My5SsjdE82gyA7zbZOfWJee
         pKgcTyueYJAOhLg94BaAyYmuljlBRjkIElKAVII4ekBcFZQ31lYsCPYD3WLlPhAB2aAc
         uW6lUPh81GC6coGOpmYZLvu7fUnHpIAiyZa6pC7zA1po66dznrWnt+rUIGNx2F3Ss5eB
         5q02JPV0H61EJ4W2jG5aUEAZijyNsBsCLUE9dIhnrxfOdEjLaeGv2i4aWgZVjKvWzb02
         rHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692912220; x=1693517020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLlmHuBmXQbShq6LQ0rDjiyEZzFGxBpm6sWhP8DUGrU=;
        b=f5qQLU4ZjVVypIvURXOCk/San+f0PKgIAS0SOieHhVEUOccd8Ka9/PtKC04r3oR1cA
         Iv9X4/gCVsviXti4YgDpnMCxZ4iRcAOk0zW7tcQtOQQkkCkT2SU1xiTfmmBFzaA7Qnz6
         WBQMAvG5Fp7T7oBo1u0+M1P1JnibW34pglZiksMjBvddCcgoTFFY+YM6AGWSrSjovzyl
         wU3DRPJTBWOrTXV9DTAVBkaIYIlMpIwI81BIAit/+k8O0ZIgvGQkfOUTqwBuEmVy2F+V
         UsrPgDnXTHb78jmqabDpUf+Q/9Yl+21fs6MHmqOjJdblSYre4vHRA7E1zIgF6iHlTgfe
         PP0Q==
X-Gm-Message-State: AOJu0Yxmvq20FrMTsyE0+EpAuGZLtGglWfjehfsnYG36Pjzrhjhq5lRp
        XMDTeuN7rBiCjx+GhF+hd+rdldQpI5+85HbVFrZPOg==
X-Google-Smtp-Source: AGHT+IHwhKa9cvrnnfzbrwDSB263QMDqCh8qhqAb2kmedotL6DvMSTtdNIZeJLtrabVxXiMxoOatjw==
X-Received: by 2002:a6b:dd16:0:b0:786:7100:72de with SMTP id f22-20020a6bdd16000000b00786710072demr7625977ioc.16.1692912220162;
        Thu, 24 Aug 2023 14:23:40 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id z21-20020a6b0a15000000b0079187c8524asm52493ioi.3.2023.08.24.14.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 14:23:39 -0700 (PDT)
Date:   Thu, 24 Aug 2023 15:23:36 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 6/9] libtraceveal: Add type checks to traceeval_data vals
 and keys
Message-ID: <20230824212336.GG110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-7-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-7-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:19PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Now that the traceeval_data has a type, add checks to traceeval_insert()
> and traceveal_query() as well as traceeval_stat() to make sure the keys
> and vals match the types that were for the traceeval.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/histograms.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index 7c0eef6cf421..560046cc8d96 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -479,10 +479,16 @@ static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
>  	struct hash_item *item;
>  	unsigned key;
>  	int check = 0;
> +	int i;
>  
>  	if (!teval || !keys)
>  		return -1;
>  
> +	for (i = 0; i < teval->nr_key_types; i++) {
> +		if (keys[i].type != teval->key_types[i].type)
> +			return -1;
> +	}
> +
>  	key = make_hash(teval, keys, hist->bits);
>  
>  	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
> @@ -928,10 +934,16 @@ int traceeval_insert(struct traceeval *teval,
>  {
>  	struct entry *entry;
>  	int check;
> +	int i;
>  
>  	entry = NULL;
>  	check = get_entry(teval, keys, &entry);
>  
> +	for (i = 0; i < teval->nr_val_types; i++) {
> +		if (vals[i].type != teval->val_types[i].type)
> +			return -1;
> +	}

I think we should have a similar type check in the update path, so do all the
checks in a loop like this in update_entry(), or we can check each entry
individually in copy_traceeval_data().

That will make sure we don't update an entry with mismatched typed values.

> +
>  	if (check == -1)
>  		return check;
>  
> -- 
> 2.40.1
> 
