Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400428EF
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 00:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708562830; cv=none; b=martQV50a/9f6BkI3aG2+lQ+dgXHkyqW6E+TmOGxEjbOaWsNvL63Nw5Y+dbMK6DJyehRi+AzmGbSPsE4Gd89XbZ9l7ahCpTfq+vG3TFwWCzq4z7npJiPa+XYX8iaKfh0BIJVLZ4/l+G9ftcZ38SXd9ebCqmcg8157bHIzPDy+kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708562830; c=relaxed/simple;
	bh=jIP9KR+0MSz1cgigzzIFYhAXex0iwR5BkqGaH8HGogk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPy4ETuL8gfYe7/uOehXms37LUyuTfsor4RnAJurarsEPto1Pq4QK3ff8feg9mzyrKX8owXG8DKmD57d+YHbz4YG736k0UIjGPf8xUchLTGVQz6Un304mPpSd4DPqO90IDEwKNV+H4w9/NvEb12188zKlBuvxsDfr5qVo6DRGtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AE5C433C7;
	Thu, 22 Feb 2024 00:47:09 +0000 (UTC)
Date: Wed, 21 Feb 2024 19:48:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5] trace-cmd split: Enable support for buffer selection
Message-ID: <20240221194857.084c6cc5@gandalf.local.home>
In-Reply-To: <20240219164320.1100880-1-pierre.gondois@arm.com>
References: <20240219164320.1100880-1-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Feb 2024 17:43:20 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

Hi Pierre,

This looks good, except I have on small nit ;-)

> @@ -120,6 +116,50 @@ static void free_handles(struct list_head *list)
>  	}
>  }
>  
> +static struct list_head inst_list;
> +
> +struct inst_list {
> +	struct list_head		list;
> +	const char			*name;

Why "const char *name" and not just "char *name"?

> +	struct handle_list		*handle;
> +
> +	/* Identify the top instance in the input trace. */
> +	bool				was_top_instance;
> +
> +	/* Identify the top instance in the output trace. */
> +	bool				is_top_instance;
> +};
> +
> +static void free_inst(struct list_head *list)
> +{
> +	struct inst_list *item, *n;
> +
> +	list_for_each_entry_safe(item, n, list, list) {
> +		list_del(&item->list);
> +		free((char *)item->name);

Then you don't need to do the typecast to free.

> +		free(item);
> +	}
> +}
> +
> +static struct inst_list *add_inst(const char *name, bool was_top_instance,
> +				  bool is_top_instance)
> +{
> +	struct inst_list *item;
> +
> +	item = calloc(1, sizeof(*item));
> +	if (!item)
> +		die("Failed to allocate output_file item");
> +
> +	item->name = strdup(name);

You are using strdup(), which means "name" isn't pointing to a const.

-- Steve

> +	if (!item->name)
> +		die("Failed to duplicate %s", name);
> +
> +	item->was_top_instance = was_top_instance;
> +	item->is_top_instance = is_top_instance;
> +	list_add_tail(&item->list, &inst_list);
> +	return item;
> +}
> +
