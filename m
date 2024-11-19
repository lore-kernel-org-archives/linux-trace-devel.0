Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9B314A60C
	for <linux-trace-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732053702; cv=none; b=G5DwVfIRhfZ73FmT7RCUxW+OMp8gkNDAismy5ykpd4udvaq36I/ahIZFHYsry6vPKBoohrdc/cA0PgVX5BYpsUZ6vdA8l4tOa4dYTQmz6tq/vJ82y9cVGJ4+RgK9x39qnpLprFtZUtHDSDloDadc1OaST2OHAIN370o8uICU5FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732053702; c=relaxed/simple;
	bh=nx/bn8s/8NamM/KF/zOa37WvNsgUKfFsiZDj/2qCoMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qnbllsem4HN0uFTy3T+kr4OZMvWQH0vcl9/r30sZQFEpEP5gf6RTGqzFTpGseGDhXPVxqg4UQZYLrZGSKfCnzMEN0yFuYwRGBhxN/QACFwL4fs2GBTi7s3C0UQhn2M5ZCo5T28RUTM8ndm6wQlA1JioGs2/ao7XVyaijBPQFK2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=none smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=liA/E57k; arc=none smtp.client-ip=217.70.183.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="liA/E57k"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 11C78C0002;
	Tue, 19 Nov 2024 22:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1732053690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twSvpuRy2I37tGXTXzAzW6TAmaFAf3sL4k+ZdsNfL6c=;
	b=liA/E57kmiMwqSbQP9Ddkt2tArmEIrsiiykNNDXXMGqvVEThHRGz5O50Rn7/LxoEcCpdcG
	VI765lL1CbyL3BlbYNiT/N+sptCoAIvPj4WivnKKLDr3MOM1DwRzb7Z/xJhxWXPQlS3LbC
	8J2IB7y3efK2D/xGAe6oWRazgjS2b/fGVglWa6luGV5h9ZIW/KDHiVlFK1NhDVWCNk68g5
	PVu7W645AuR0pIuObQlKBaSeBiLJIQT0dqJhXTotFZk6eFfPhS3b2qxV7HgAaPxFSY/d0P
	bTu5Os+PazN4bN0LFmlByfAFD3z/5fmGCWN/Mo2gRdbB5aacnU6eNpgeZZjt0A==
Message-ID: <16416d8a-fbc4-45e7-b72d-fcfedce2e9e5@yoseli.org>
Date: Tue, 19 Nov 2024 23:01:29 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtraceevent: Handle case of unknown operator
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20241119151809.4da5f874@gandalf.local.home>
Content-Language: en-US
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
In-Reply-To: <20241119151809.4da5f874@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

Hello Steve,

On 19/11/2024 21:18, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The m68k architecture had a trace event with "m68k_memory[0].addr >> 13"
> in it. The parsing after the ']' and before the '.' checked the priority
> of the '.' but because it does not handle '.' as an operator it returned a
> negative number. But process_op() did not check for an error and continued
> processing. This caused a segfault.
> 
> Return immediately if the operator is not handled by get_op_prio().
> 
> Link: https://lore.kernel.org/all/20241119112850.219834f5@gandalf.local.home/
> 
> Reported-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> Fixes: 6582b0aea1cc ("tools/events: Add files to create libtraceevent.a")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thank you for your patch !
Tested-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

> ---
>   src/event-parse.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 0427061603db..a6da8f04cbf3 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2498,6 +2498,10 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
>   
>   		/* higher prios need to be closer to the root */
>   		prio = get_op_prio(*tok);
> +		if (prio < 0) {
> +			token = *tok;
> +			goto out_free;
> +		}
>   
>   		if (prio > arg->op.prio)
>   			return process_op(event, arg, tok);

