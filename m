Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8E2D27A
	for <linux-trace-devel@vger.kernel.org>; Fri, 16 Feb 2024 03:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708053773; cv=none; b=ddxRQsRHqJIDIpMq2kI43AlUN4LfrUHOJI3xBo7JQeNtvs4lEcBH8qKEQiI7fnSrYqaHYbh7kM9gFH1/cmQN/GreYLUZ6n5D21Rxy+p2zNHwxXKNj021veK0ecjQy63v7hPikdNpf6qkktcu4X+jUgBpCSg5WcIsRPU6BucH+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708053773; c=relaxed/simple;
	bh=UPpkawLlHcpz5H3MO2xIsW202zrdd+eJIHghwyAP+Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lyg24WTID0Bui0q05CLSFf038rke8bVURNVc00metSCdzQbC/vwGK9RyV+tlDpgypLNCjx+VjVkPFKP7tUCjHdvxEbg6uEOF3zZtkariQLqpZcWTepRuQaDozGxT7V0It9zO2c8G6Zkb151CVgEAjpXoUJB4svztFLTNfdeIcOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC90C433F1;
	Fri, 16 Feb 2024 03:22:52 +0000 (UTC)
Date: Thu, 15 Feb 2024 22:24:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4] trace-cmd split: Enable support for buffer selection
Message-ID: <20240215222427.71746f76@gandalf.local.home>
In-Reply-To: <20240214174013.68568-1-pierre.gondois@arm.com>
References: <20240214174013.68568-1-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Feb 2024 18:40:13 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> --- a/tracecmd/trace-split.c
> +++ b/tracecmd/trace-split.c
> @@ -55,13 +55,10 @@ struct handle_list {
>  	struct list_head		list;
>  	const char			*name;
>  	int				index;
> -	struct tracecmd_input 		*handle;
> +	struct tracecmd_input		*handle;
>  
>  	/* Identify the top instance in the input trace. */
>  	bool				was_top_instance;
> -
> -	/* Identify the top instance in each output trace. */
> -	bool				is_top_instance;
>  };
>  
>  static struct list_head handle_list;
> @@ -120,6 +117,51 @@ static void free_handles(struct list_head *list)
>  	}
>  }
>  
> +static struct list_head inst_list;
> +
> +struct inst_list {
> +	struct list_head		list;
> +	const char			*name;
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
> +	struct inst_list *item;
> +
> +	while (!list_empty(list)) {
> +		item = container_of(list->next, struct inst_list, list);
> +		list_del(&item->list);
> +		free((char *)item->name);
> +		free(item);
> +	}

Nit, the above could be simplified as:

	struct inst_list *item, *n;

	list_for_each_entry_safe(item, n, head, list) {
		list_del(&item->list);
		free((char *)item->name);
		free(item);
	}

That way you don't need to deal with "container_of()".

> +}
> +
