Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD0B136E09
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jun 2024 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718394558; cv=none; b=bcMcOaUxlq0fFVRjcam6nbMJ08/1HtVBtMklpd/mLcYMxLiu+zA/PIQ2M7qlrjLw6HAy8xPaD31Obl6O9mAb08KD11OeVuUz4vYinHbefuS3ibGcvX+qlhRP90xm3oKyFmIBh+8Du8Q0B5oQy0SI2QHIADiwWfENVbo4msEQ3Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718394558; c=relaxed/simple;
	bh=ViUIXwp0a4S581QrgR8sUydpvtWWE0jIZWe6VjJS69A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=At1Q9Winy7HCxbCvZSmT9xBGMsQraemESEedOw5FSNLaaSu6WqjBRl1kJNsAjsuCEtoQCZuWTCbFqpE0A4hyR0pENxkEETS+opKfkQMv3PkqFKz5Wv/O2rxI3Cdj/3mEIo+UoCPQoYAF3+w8cUBNI7gdR/KbpXcjERXnEZcsOm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D02BC2BD10;
	Fri, 14 Jun 2024 19:49:17 +0000 (UTC)
Date: Fri, 14 Jun 2024 15:49:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 4/4] libtraceevent: don't return a pointer to a local
 variable get_field_str()
Message-ID: <20240614154916.6e63bd2d@rorschach.local.home>
In-Reply-To: <20240607160542.46152-5-jmarchan@redhat.com>
References: <20240607160542.46152-1-jmarchan@redhat.com>
	<20240607160542.46152-5-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  7 Jun 2024 18:05:42 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> The function get_field_str() can return a pointer to string on the
> stack. Replace it by a global variable.
> 
> Fixes a RETURN_LOCAL error (CWE-562)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  src/parse-filter.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/parse-filter.c b/src/parse-filter.c
> index e448ee2..f0c0ae1 100644
> --- a/src/parse-filter.c
> +++ b/src/parse-filter.c
> @@ -1698,6 +1698,8 @@ static int test_num(struct tep_event *event, struct tep_filter_arg *arg,
>  	}
>  }
>  
> +char hex[64];
> +
>  static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *record)
>  {
>  	struct tep_event *event;
> @@ -1705,7 +1707,6 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
>  	unsigned long long addr;
>  	const char *val = NULL;
>  	unsigned int size;
> -	char hex[64];

Instead of making hex a global variable (which is incorrect for
multiple reasons, and can caus bugs elsewhere). Just make it a static
variable here.

	static char hex[64];

I'll fix this and give you a reported-by.

-- Steve


>  
>  	/* If the field is not a string convert it */
>  	if (arg->str.field->flags & TEP_FIELD_IS_STRING) {

