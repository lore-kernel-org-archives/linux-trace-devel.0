Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334871D3199
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 08:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729154322; cv=none; b=dp60OoAQS42f25n1ZcLeNoJrPtMZQMpOoVAgHTJnAAaEjoXsJZdd1MSBG+8ZJqv+t6nvkailJ15hi5FS2dxPdhh2DMncj1xRDnWhs+dXH1xdRqdJZ1HAvwhwOr1QebHAN46cnPgPvnZbDEx/0Fj6sEIQ0IW7yX1LU7lCVs2VTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729154322; c=relaxed/simple;
	bh=W9QkIodpLkz8AvJySI6Z51J+wI3BUxo/go1yjpXFmkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=T9e64wZ9fEIqwMlzodqRaMQJ56qXBvovUeJsQ3RFfwLQghrFZIp2XdPqyRPUwyE8F523lGH6GDSdtvFU8iDn8c8Lu73CcqFzOAbVOsCh68sHlXiZZY/1a06S8L9Bo+QkPbj+HkeogQyi1l7g1DFlxMapubzIB/nZKPdTGPAbcQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 016A3FEC;
	Thu, 17 Oct 2024 01:39:08 -0700 (PDT)
Received: from [10.57.21.119] (unknown [10.57.21.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4DC83F71E;
	Thu, 17 Oct 2024 01:38:37 -0700 (PDT)
Message-ID: <e6ddd9b6-ce83-451e-8344-24ff620245cc@arm.com>
Date: Thu, 17 Oct 2024 09:38:35 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracefs: Destroy synthetic and eprobes before other
 events
To: Steven Rostedt <rostedt@goodmis.org>
References: <20241016123552.55efa78f@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
In-Reply-To: <20241016123552.55efa78f@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2024 5:35 pm, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Synthetic events can be based on eprobes and other dynamic events. When
> destroying multiple events via tracefs_dynevent_destroy() make sure to
> remove the synthetic events first, followed by eprobes (as they can be on
> other dynamic events as well), then the rest of the dynamic events.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   src/tracefs-dynevents.c | 42 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 6df7212fb38e..77bdf94fdbfe 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -654,6 +654,22 @@ tracefs_dynevent_get(enum tracefs_dynevent_type type, const char *system,
>   	return devent;
>   }
>   
> +static int destroy_dynevents(struct tracefs_dynevent **all, bool force)
> +{
> +	int ret = 0;
> +	int i;
> +
> +	if (!all)
> +		return 0;
> +
> +	for (i = 0; all[i]; i++) {
> +		if (tracefs_dynevent_destroy(all[i], force))
> +			ret = -1;
> +	}
> +
> +	return ret;
> +}
> +
>   /**
>    * tracefs_dynevent_destroy_all - removes all dynamic events of given types from the system
>    * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
> @@ -671,16 +687,32 @@ int tracefs_dynevent_destroy_all(unsigned int types, bool force)
>   {
>   	struct tracefs_dynevent **all;
>   	int ret = 0;
> -	int i;
>   
> +	/*
> +	 * Destroy synthetic events first, as they may depend on
> +	 * other dynamic events.
> +	 */
> +	if (types & TRACEFS_DYNEVENT_SYNTH) {
> +		all = tracefs_dynevent_get_all(TRACEFS_DYNEVENT_SYNTH, NULL);
> +		ret = destroy_dynevents(all, force);
> +		tracefs_dynevent_list_free(all);
> +		types &= ~TRACEFS_DYNEVENT_SYNTH;
> +	}
> +
> +	/* Eprobes may depend on other events as well */
> +	if (types & TRACEFS_DYNEVENT_EPROBE) {
> +		all = tracefs_dynevent_get_all(TRACEFS_DYNEVENT_EPROBE, NULL);
> +		ret |= destroy_dynevents(all, force);
> +		tracefs_dynevent_list_free(all);
> +		types &= ~TRACEFS_DYNEVENT_EPROBE;
> +	}
> +
> +	/* Destroy the rest */
>   	all = tracefs_dynevent_get_all(types, NULL);
>   	if (!all)
>   		return 0;
>   
> -	for (i = 0; all[i]; i++) {
> -		if (tracefs_dynevent_destroy(all[i], force))
> -			ret = -1;
> -	}
> +	ret |= destroy_dynevents(all, force);
>   
>   	tracefs_dynevent_list_free(all);
>   


I see one more failure in this section of unit tests:

   Test: tracefs_iterate_snapshot_events API ...FAILED
     1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
     2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
     3. tracefs-utest.c:235  - ret == sizeof(struct test_sample)

I did run trace-cmd reset and unmounted my tracefs before running the 
unit tests.
Please feel free to ignore if something is weirdly wrong in my setup.

Other than that -kind of existing- failure, the patch looks good to me 
(e.g., trace-cmd unit tests are working fine).
