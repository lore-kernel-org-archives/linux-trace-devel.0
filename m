Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482BE23A99D
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744393358; cv=none; b=eAQZu8DP4C9M+RUQX2aEU2jVZfTOcxQipas6fBs6xIotK4k0XJekYo2KNYYatPYB1dLyxyEg8Z2VwVoxW4rHYe8LDTqjUpZLcZIz8yAH+FXYl2XtGmv/HIvejOhTKBBv8HPUjxyvMTpBDzmAXHgWiQqVDFsruy4jrsTiP5kFhgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744393358; c=relaxed/simple;
	bh=3FAYY+68weHOBNiFC4r3K25Iw+D2JwKCJEZjwkcwpb8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOFOREMZ1aEFsNP5zbSyxIn+0S9MjnNX8xbCaJPRMIlTd8+q55XEyzUVNh2Zegwwo5RA30OBxYyfIHlqzLfBoEgInUnFJrrrAhFZIDKJZchDRneG2WH+PFojfoENZACLpcf5qKL+65lb0kVI88GKqgNHwjStG5Qe3XHzQdfftm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F60EC4CEE2;
	Fri, 11 Apr 2025 17:42:36 +0000 (UTC)
Date: Fri, 11 Apr 2025 13:44:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>
Subject: Re: [PATCH] trace-cmd record: Fix compression on big-endian systems
Message-ID: <20250411134401.3d3e62d7@gandalf.local.home>
In-Reply-To: <20250411172815.61477-1-iii@linux.ibm.com>
References: <20250411172815.61477-1-iii@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Apr 2025 19:27:56 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> trace-cmd report prints nothing on s390x when compression is used.
> 
> The reason is that the code treats size_t pointers as int pointers when
> serializing size_t values into 32-bit on-disk fields, which works only
> on little-endian systems.
> 
> Fix serialization by copying size_t values into int values first.
> While at it, add overflow checks.
> 
> Fixes: 176bc1f14419 ("trace-cmd record: Fix compression when files are greater than 2GB")

Thanks for the fix, but I have some comments below.

> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  lib/trace-cmd/trace-compress.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
> index 03215ad1..1b599043 100644
> --- a/lib/trace-cmd/trace-compress.c
> +++ b/lib/trace-cmd/trace-compress.c
> @@ -7,6 +7,7 @@
>  #include <sys/time.h>
>  #include <fcntl.h>
>  #include <errno.h>
> +#include <limits.h>
>  #include <unistd.h>
>  
>  #include "trace-cmd-private.h"
> @@ -331,7 +332,12 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
>  		goto out;
>  
>  	/* Write uncompressed data size */
> -	endian4 = tep_read_number(handle->tep, &handle->pointer, 4);
> +	if (handle->pointer > UINT_MAX) {
> +		ret = -1;
> +		goto out;
> +	}
> +	endian4 = handle->pointer;
> +	endian4 = tep_read_number(handle->tep, &endian4, 4);
>  	ret = do_write(handle, &endian4, 4);
>  	if (ret != 4) {
>  		ret = -1;
> @@ -735,13 +741,19 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
>  			}
>  			size = ret;
>  			/* Write compressed data size */
> -			endian4 = tep_read_number(handle->tep, &size, 4);
> +			if (size > UINT_MAX)
> +				break;
> +			endian4 = size;
> +			endian4 = tep_read_number(handle->tep, &endian4, 4);
>  			ret = write_fd(handle->fd, &endian4, 4);
>  			if (ret != 4)
>  				break;
>  
>  			/* Write uncompressed data size */
> -			endian4 = tep_read_number(handle->tep, &all, 4);
> +			if (all > UINT_MAX)
> +				break;
> +			endian4 = all;
> +			endian4 = tep_read_number(handle->tep, &endian4, 4);
>  			ret = write_fd(handle->fd, &endian4, 4);
>  			if (ret != 4)
>  				break;
> @@ -763,9 +775,13 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
>  	if (lseek(handle->fd, offset, SEEK_SET) == (off_t)-1)
>  		return -1;
>  
> -	endian4 = tep_read_number(handle->tep, &chunks, 4);
> +	if (chunks > UINT_MAX)
> +		return -1;
> +	endian4 = chunks;
> +	endian4 = tep_read_number(handle->tep, &endian4, 4);

You do the same conversion 4 times. Could you make a helper function
instead?

static int read_size_val(struct tep_handle *tep, size_t size, int *endian4)
{
	if (size > UINT_MAX)
		return -1;

	*endian4 = size;
	*endian4 = tep_read_number(tep, endian4, 4);
	return 0;
}

Then you can change the above to:

	if (read_size_val(handle->tep, chunks, &endian4) < 0)
		return -1;

Same with the rest.


>  	/* write chunks count*/
> -	write_fd(handle->fd, &chunks, 4);
> +	if (write_fd(handle->fd, &endian4, 4) != 4)
> +		return -1;

This is a separate issue and should be a separate patch.

>  	end_offset = lseek(handle->fd, 0, SEEK_END);
>  	if (end_offset == (off_t)-1)
>  		return -1;

Thanks,

-- Steve
