Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC82C001DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Aug 2023 23:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjHGXkV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Aug 2023 19:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjHGXkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Aug 2023 19:40:19 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CEF198C
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Aug 2023 16:40:18 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7878e573827so162328739f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Aug 2023 16:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691451617; x=1692056417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZG37yqjXl9cQIEspDvZ2c0w2XelfA9qD7UzB8F8FJ2A=;
        b=kFzNMgd7O9W83gFVdIqRWzOoOxuwi78DvobAhq+DJ1Yt33lpYNn3S5fT7arhKMAdRC
         IP1S3uM8WAhy929rUrPYLU0sYkuCmjNagf+F2qZHFb2MjHCfbahYoD2lprmouUumAnWT
         IuKSW+YqpAb1piRcCNbyO+p2rB9uED92sNFhmMIdB2ob4A6SedCiVdSnXV81LbwG4UnW
         AlrjsiDdhQdRTq34NHqGglpylOYJDlV8Bg9Ik6jMXG/79KpsGyajCO+F21lxLdl/ZsTi
         SZhQ/uDnjuhN75f/1suG3XjagWSQ/+DKEQbKkq1buQg1zB4fPYG4XcgsaIVMtizW1YbB
         4ltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691451617; x=1692056417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZG37yqjXl9cQIEspDvZ2c0w2XelfA9qD7UzB8F8FJ2A=;
        b=XvDph/qaIXIzG3vndnlrMgbb54bdscBvolWC7SU2ApDQC8f++bB05qenTe0A5Glm3y
         DvADChQfsYLvVNeQfY+O5uNY3H+2H+qVIxrYby7yoD5tNrNf+vrC2oQcg4Olt3wTzp0b
         kyrJgp2ZvAW8F6kYXP9viJzkBQn9afx5unSxnzPTngo5l3yxQE+BMAqo2TQ8ilSTcDe6
         Ztv2qU5iMUjaBGuDISnS0Z+kfKoZiKUNbIBH2TRAw0tGdBzHSBdwa6vMKrUbXv8f23Yb
         kfgx7Z3V+6HU64MIWxjdgOPdZOvnjN3AEYDw8VQrfPPCk0uQoX1ZwNT4Y1YBItn0DJCt
         32kQ==
X-Gm-Message-State: AOJu0Yy47pNyeX3qDxmsPhOLAeD9sJCOUzfEPGs95ZA2k9u9HtHDaJmp
        TLOMFUhRBZmW32Ks2wN2AtKMPqocIuJu8/juUuKSTA==
X-Google-Smtp-Source: AGHT+IGbF9Z2hVeIQeOurIZH7yDSst1UfVnrY5agW/9CTpxsYAyA5TzfPZLYDU6vEWpAaId1550UNA==
X-Received: by 2002:a6b:c408:0:b0:790:9460:6304 with SMTP id y8-20020a6bc408000000b0079094606304mr11854396ioa.5.1691451617532;
        Mon, 07 Aug 2023 16:40:17 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:33ca:bcf:b9b2:c8fd])
        by smtp.gmail.com with ESMTPSA id v23-20020a5d9057000000b0078714764ca0sm3273283ioq.40.2023.08.07.16.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 16:40:16 -0700 (PDT)
Date:   Mon, 7 Aug 2023 17:40:13 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 4/5] histograms: Add traceeval compare
Message-ID: <20230807234013.GA99888@google.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
 <20230803225413.40697-5-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803225413.40697-5-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 06:54:02PM -0400, Stevie Alvarez wrote:
> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> traceeval_compare() compares two struct traceeval instances for
> equality. This suite of comparitors was made for testing purposes.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-test.h |  16 +++
>  src/histograms.c         | 221 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 234 insertions(+), 3 deletions(-)
>  create mode 100644 include/traceeval-test.h
> 
> diff --git a/include/traceeval-test.h b/include/traceeval-test.h
> new file mode 100644
> index 0000000..bb8092a
> --- /dev/null
> +++ b/include/traceeval-test.h
<>
> @@ -158,12 +172,13 @@ fail_type_name:
>   * The @keys and @vals passed in are copied for internal use.
>   *
>   * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
> - * the name field must be a null-terminated string. For members of type
> - * TRACEEVAL_TYPE_NONE, the name is ignored.
> + * the name field must be a null-terminated string. Members of type
> + * TRACEEVAL_TYPE_NONE are used to terminate the array, therefore their other
> + * fields are ignored.
>   *
>   * @vals can be NULL or start with its type field as TRACEEVAL_TYPE_NONE to
>   * define the values of the histogram to be empty.
> - * @keys must be populated with at least one element that is not
> + * @keys must be populated with at least one element that is not of type

These two comment updates seem accidental, and can be just folded into the
initial patch that creates them.

>   * TRACEEVAL_TYPE_NONE.
>   *
>   * Returns the descriptor on success, or NULL on error.
> @@ -305,3 +320,203 @@ void traceeval_release(struct traceeval *teval)
>  	teval->val_types = NULL;
>  	free(teval);
>  }
> +
> +/*
> + * Compare traceeval_type instances for equality.
> + *
> + * Return 0 if @orig and @copy are the same, 1 otherwise.
> + */
> +static int compare_traceeval_type(struct traceeval_type *orig,
> +		struct traceeval_type *copy, size_t orig_size, size_t copy_size)
> +{
> +	size_t i;
> +
> +	/* same memory/NULL */
> +	if (orig == copy)
> +		return 0;
> +	if (!!orig != !!copy)
> +		return 1;
> +
> +	if (orig_size != copy_size)
> +		return 1;
> +
> +	for (i = 0; i < orig_size; i++) {
> +		if (orig[i].type != copy[i].type)
> +			return 1;
> +		if (orig[i].flags != copy[i].flags)
> +			return 1;
> +		if (orig[i].id != copy[i].id)
> +			return 1;
> +		if (orig[i].dyn_release != copy[i].dyn_release)
> +			return 1;
> +		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
> +			return 1;
> +
> +		// make sure both names are same type
> +		if (!!orig[i].name != !!copy[i].name)
> +			return 1;
> +		if (!orig[i].name)
> +			continue;
> +		if (strcmp(orig[i].name, copy[i].name) != 0)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Compare traceeval_data instances.
> + *
> + * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
> + * -1 for the other way around, and -2 on error.
> + */
> +static int compare_traceeval_data(union traceeval_data *orig,

For both this and compare_traceeval_data_set(), both 'orig' and 'copy' can be
const.   Same with 'type', since compare functions shouldn't be modifying any
data.  This applies to most or all of the pointer params to your compare
functions.

> +		const union traceeval_data *copy, struct traceeval_type *type)
> +{
> +	int i;
> +
> +	if (orig == copy)
> +		return 0;
> +
> +	if (!orig)
> +		return -1;
> +
> +	if (!copy)
> +		return 1;
> +
> +	switch (type->type) {
> +	case TRACEEVAL_TYPE_STRING:
> +		i = strcmp(orig->string, copy->string);
> +		compare_numbers_return(i, 0);
> +
> +	case TRACEEVAL_TYPE_NUMBER:
> +		compare_numbers_return(orig->number, copy->number);
> +
> +	case TRACEEVAL_TYPE_NUMBER_64:
> +		compare_numbers_return(orig->number_64, copy->number_64);
> +
> +	case TRACEEVAL_TYPE_NUMBER_32:
> +		compare_numbers_return(orig->number_32, copy->number_32);
> +
> +	case TRACEEVAL_TYPE_NUMBER_16:
> +		compare_numbers_return(orig->number_16, copy->number_16);
> +
> +	case TRACEEVAL_TYPE_NUMBER_8:
> +		compare_numbers_return(orig->number_8, copy->number_8);
> +
> +	case TRACEEVAL_TYPE_DYNAMIC:
> +		if (type->dyn_cmp)
> +			return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
> +		return 0;
> +
> +	default:
> +		print_err("%d is an invalid enum traceeval_data_type member",
> +				type->type);
> +		return -2;
> +	}
> +}
> +
> +/*
> + * Compare arrays of union traceeval_data's with respect to @def.
> + *
> + * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
> + */
> +static int compare_traceeval_data_set(union traceeval_data *orig,
> +		const union traceeval_data *copy, struct traceeval_type *defs,
> +		size_t size)
