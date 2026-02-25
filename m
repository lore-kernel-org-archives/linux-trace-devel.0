Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0BA31A567
	for <linux-trace-devel@vger.kernel.org>; Wed, 25 Feb 2026 23:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772062558; cv=none; b=jP2wy30R7q3eHkl8EF4DsbZaKxj4kSqsnAZJdUG93UDnFqG/IheIn5qqarY8OUVG0Gt+2pZTGgg0ftYOh5M9/+gF4wweQEVC0EegPmuf4l0c6/2XLwwQUjpIU+1Ly19OOylCEd5A08DDUNPQza9/qWDbHc20BBP0HkBnd+z/Clc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772062558; c=relaxed/simple;
	bh=pvwntT/TmX8HecnCBw/ME40yExvXo7vDLgKjCRYshzA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HQc7EyB1pLC8xV2cHWMrHo0YaYXtrgaVvPEywuauVnJOIFZld3lTtZelXB6WQQjSUtYvMOXOP3TlQcEO9o4ZuXSLYNIZg+i790vW3H3DUy0178Lp1qVBB9tjfsQyUZeJnfmIk6AWnedD+Sjcfwy/7/CPLkLrqM/Z4eTTZJ5m9Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B42989885;
	Wed, 25 Feb 2026 23:35:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 9CD0020025;
	Wed, 25 Feb 2026 23:35:48 +0000 (UTC)
Date: Wed, 25 Feb 2026 18:35:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ciunas Bennett <ciunas@linux.ibm.com>
Cc: linux-trace-devel@vger.kernel.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH] kernelshark: Fix TEP filter array parsing logic
Message-ID: <20260225183542.34135df4@fedora>
In-Reply-To: <20260224170528.728883-1-ciunas@linux.ibm.com>
References: <20260224170528.728883-1-ciunas@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 9CD0020025
X-Stat-Signature: rdmkwcmtb8igat9jps36qcerp6f14h8m
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Q0CM4q52f25hq5pKtDNdIoHiQjTWkb54=
X-HE-Tag: 1772062548-325702
X-HE-Meta: U2FsdGVkX19fvzNM+qs2sAXOxzzBie4tZBoU0NgvYITvoony4ZhpWHGlB7E4K8oFSOBwtRCGXq1XvmAiA8Wgo9y+QzpBd/T0HEetAotMfyKuWlXowabRt1yLkTX1zhMygR7JYSnAMJEUSMQqdJAXEur4pE7utTk4hDbHNhXG76pQLGp8Oe+e+b2T8T5Crq/2P16DeTG+IK7h9vlkVRRW2xuz4nh7V8V0EvHFgITDUbWFZ0M+xb2/suFh5BThD2uQkSIAoWLgYweGyIEAUBXLeKncSkjSyQDDJKVNueCnlWOst5JvA4qIko6vYNwY2S84JSz3DYZLzt2JghnPy9tSNqTozzDusny/

On Tue, 24 Feb 2026 17:05:25 +0000
Ciunas Bennett <ciunas@linux.ibm.com> wrote:

Thanks, I'm adding Yordan to the Cc as he's maintaining KernelShark.

-- Steve


> When saving a session with more than a single TEP advanced filter,
> KernelShark triggers a json-c assertion:
> 
> "json_object_array_get_idx: Assertion
> `json_object_get_type(jso) == json_type_array' failed."
> 
> This is caused because the code reuses the `jfilter` variable inside
> the loop to fetch each array element:
> 
>     jfilter = json_object_array_get_idx(jfilter, i);
> 
> This overwrites the original array object. On the next iteration,
> `jfilter` is no longer a json_type_array, causing the assertion.
> 
> Fix this by introducing a temporary variable `jitem` to store each
> array element, leaving `jfilter` to point to the actual array.
> 
> Signed-off-by: Ciunas Bennett <ciunas@linux.ibm.com>
> ---
>  src/libkshark-configio.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
> index 88c2c9a..568ec73 100644
> --- a/src/libkshark-configio.c
> +++ b/src/libkshark-configio.c
> @@ -1528,7 +1528,7 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx, int sd,
>  static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
>  					 struct json_object *jobj)
>  {
> -	json_object *jfilter, *jname, *jcond;
> +	json_object *jfilter, *jname, *jcond, *jitem;
>  	int i, length, n, ret = 0;
>  	char *filter_str = NULL;
>  
> @@ -1548,10 +1548,10 @@ static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
>  	/* Set the filter. */
>  	length = json_object_array_length(jfilter);
>  	for (i = 0; i < length; ++i) {
> -		jfilter = json_object_array_get_idx(jfilter, i);
> +		jitem = json_object_array_get_idx(jfilter, i);
>  
> -		if (!json_object_object_get_ex(jfilter, "name", &jname) ||
> -		    !json_object_object_get_ex(jfilter, "condition", &jcond))
> +		if (!json_object_object_get_ex(jitem, "name", &jname) ||
> +		    !json_object_object_get_ex(jitem, "condition", &jcond))
>  			goto fail;
>  
>  		n = asprintf(&filter_str, "%s:%s",

		
