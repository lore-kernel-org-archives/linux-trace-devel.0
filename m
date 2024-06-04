Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629CB4C91
	for <linux-trace-devel@vger.kernel.org>; Tue,  4 Jun 2024 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717513973; cv=none; b=FziWij1L0Aty72uKDMrv9CQKqBT+88yeN2O/HPOmbMQoENOkBm3LFR5qpjR6N75DOdUj6Fj6nnUoMMbt/4rVRUi/7Y4wvJ6e5OjrthD2iVblYGo+UtWGOAvJ6lrrRGRFE4NiHgoeT3mE/t+8YvSELv7E4NvvIO2TbgDKgM4cFCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717513973; c=relaxed/simple;
	bh=vz0TCfkLL2qLZcMKkncbQuZOl4FEBsMUY84NQilr5sE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bYtVWPJ1/mTRF7gc7zlyoSChAXw7O0uIOQ8FdFG9tf+001SKpVKWOZDoS9/6gqb//9ryrFtcTDF6zZKFqiyFXASK500UuWAoWA60P+DFrcMdjFuRqGLbPFE534SlSXS867caqahWtuUQ9F/gY+7MBZR4r/G+IgP4+z6iUzQBALI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ru1x19ln; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OqO1mY9Z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ru1x19ln; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OqO1mY9Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ru1x19ln";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OqO1mY9Z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ru1x19ln";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OqO1mY9Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 874A11F7FE;
	Tue,  4 Jun 2024 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717513969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6vUscU0yorXvliwCXR27HFkWlxmVo4f5tj3bLcRZ1yQ=;
	b=Ru1x19lngbXIj2+EXmIcjmZB3vJrH2gvLRDveV0RC8yciaJEvqZP7Hri8oAh0vkHrLESJv
	IGjJuxCV5ofmh0LoGuJKg1Pnye6WdZydMDC2TML7Vdq85pkLA7hFRGgxiQfw9ZsoiHv3Jc
	DRfuHHu/9o1Ae45qkUg4+K+RvMToPSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717513969;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6vUscU0yorXvliwCXR27HFkWlxmVo4f5tj3bLcRZ1yQ=;
	b=OqO1mY9ZtbarXat2iRyhDzxUAiABYoNHIlAPhUcxwV6qe5TOXN8xoihXAUZ0fpe8pewqKo
	SojEer6B34vDOfDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717513969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6vUscU0yorXvliwCXR27HFkWlxmVo4f5tj3bLcRZ1yQ=;
	b=Ru1x19lngbXIj2+EXmIcjmZB3vJrH2gvLRDveV0RC8yciaJEvqZP7Hri8oAh0vkHrLESJv
	IGjJuxCV5ofmh0LoGuJKg1Pnye6WdZydMDC2TML7Vdq85pkLA7hFRGgxiQfw9ZsoiHv3Jc
	DRfuHHu/9o1Ae45qkUg4+K+RvMToPSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717513969;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6vUscU0yorXvliwCXR27HFkWlxmVo4f5tj3bLcRZ1yQ=;
	b=OqO1mY9ZtbarXat2iRyhDzxUAiABYoNHIlAPhUcxwV6qe5TOXN8xoihXAUZ0fpe8pewqKo
	SojEer6B34vDOfDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B5B613ABC;
	Tue,  4 Jun 2024 15:12:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yCPEHfEuX2aAIAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jun 2024 15:12:49 +0000
Message-ID: <6926538c-90ad-43a6-8b17-f5e2fd1c67eb@suse.cz>
Date: Tue, 4 Jun 2024 17:12:49 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] trace-cmd: Do not print stacks after stacks
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240528113141.7a3e8a04@rorschach.local.home>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240528113141.7a3e8a04@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/28/24 5:31 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> When a filter is in place, the stack trace for the events that are
> printed by the filter should also be printed. Stack traces for events
> that are filtered out, should also be filtered out. But there was a bug
> in the logic that checked if the last event was printed or not to know
> to print the stack, and that is, the stack from the printed event was
> considered a printed event itself. So a stack trace coming from another
> event could be considered "printed" if two stacks came back to back
> (which can happen because of interrupts.
> 
> Note, this does mean that logic should be added to test for interrupts.
> But that's another story.
> 
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Fixes: 82ed4a937 ("trace-cmd library: Add filtering logic for iterating events")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Seems to work as intended now. Thanks!
Tested-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  lib/trace-cmd/trace-filter.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-filter.c b/lib/trace-cmd/trace-filter.c
> index 1c8c07fc..99423223 100644
> --- a/lib/trace-cmd/trace-filter.c
> +++ b/lib/trace-cmd/trace-filter.c
> @@ -47,6 +47,7 @@ static bool test_stacktraces(struct tracecmd_filter *filter, struct tep_record *
>  __hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
>  						     struct tep_record *record)
>  {
> +	bool is_stack = false;
>  	bool found = false;
>  	int ret;
>  	int i;
> @@ -94,6 +95,8 @@ __hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *fil
>  		/* If this is a stack trace and the last event was printed continue */
>  		if (!test_stacktraces(filter, record))
>  			return TRACECMD_FILTER_MISS;
> +
> +		is_stack = true;
>  	}
>  
>  	found = false;
> @@ -110,7 +113,7 @@ __hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *fil
>  	}
>  
>  	if (filter->last_printed)
> -		filter->last_printed[record->cpu] = !found;
> +		filter->last_printed[record->cpu] = !is_stack && !found;
>  
>  	return found ? TRACECMD_FILTER_MISS : TRACECMD_FILTER_MATCH;
>  }

