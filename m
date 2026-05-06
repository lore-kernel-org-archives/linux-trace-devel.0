Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A4C23D7FF
	for <linux-trace-devel@vger.kernel.org>; Wed,  6 May 2026 13:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778074078; cv=none; b=b4j5/vLn+yqrkRzlUaDUDX8P9nydHV2HozhYhVdsXMsSatLx4eRaQsYqiCZqO6g0xo7SkMmpYgnqZJUAt6GtxpGIVygDFRBon0zwWWr073wFinoKYfdt3Q7TmHroXKHegzNJltGNWiuW9l9GPSJjI+MXDNO6Ypzie2QaLoGlsKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778074078; c=relaxed/simple;
	bh=N3YsXvub78C8rfG7YiJ06XqJ7OC0bs4Wlkr4oKA+Tjc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKpnEWTcPjVfQmkVl3Gwp3SS7gLfuwIsOC9Luiop8aG3vIMgS2WSx5OoDqFnvwxbbM4+kzbv4AhZ01bvzIfuMa09h8KU9U952JIg648GHaku5RMh81lxs+iHGW+l2yIxU2fpRscRJ8lyGzF0QobKCoJGaszzB71+/zS0w2kBeIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86D908B338;
	Wed,  6 May 2026 13:27:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id B15712F;
	Wed,  6 May 2026 13:27:46 +0000 (UTC)
Date: Wed, 6 May 2026 09:27:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Emil Thorsoe <ethorsoe@tuxera.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent: bail out of utest if mmap fails
Message-ID: <20260506092735.2a4b07f0@fedora>
In-Reply-To: <2677c065-b9c9-4fd1-a4a8-de4f027a0b58@tuxera.com>
References: <2677c065-b9c9-4fd1-a4a8-de4f027a0b58@tuxera.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ocbyjgcb34mbddyp1exujpdzoe9hajkw
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: B15712F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/ECmEOcaDJKy1+z9vt4NgGkjiFHnq+XbA=
X-HE-Tag: 1778074066-943487
X-HE-Meta: U2FsdGVkX1+4vnc3i6whGNsASzyxfbSfsWwci0ipPIT30XCoIB+YdSSbFha4E4rHAUc6DCPZmhhNYiQtBqqbgjLXqpRRh9TV9ErzjqfKvpuSy+PNN96wSGdnQvN85eMc474DcHIwDLZlSLJ9pFSd6Se2CLGgafRqit4TNQMZC5ljVPdVGGYNJtt2LA6E6vS928oK5xmbobyurP5VUN17X0jW/Cgd5xNwPqOmA4zbFR2CD0Mh4mGjGBq5IrmgJd3xzK4vvLD4HDhqgVaEJ+rz5oR969OopzSkYwIoHNcHUZ4lA/Z81tjamo/6odQn+oBS9aInVqt7VeMZFp2tbAf62xsVYL6Avt9c/T/ZyZfiKShP2ra/DTU8s5p51+EYJppU

On Tue, 5 May 2026 23:22:44 +0300
Emil Thorsoe <ethorsoe@tuxera.com> wrote:

> Just like, when failing to open the BTF file, failing to
> mmap the BTF is testing the test environment, not the code.
> 
> This mmap fails with ENODEV on i686 nix build on nixos-unstable.
> 
> Just bail out without failing the test, when mmap fails.
> 
> Signed-off-by: Emil Thorsoe <ethorsoe@tuxera.com>
> ---
>  utest/traceevent-utest.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
> index b62411c..df98fa1 100644
> --- a/utest/traceevent-utest.c
> +++ b/utest/traceevent-utest.c
> @@ -397,8 +397,11 @@ static void test_btf_read(void)
>  	CU_TEST(fstat(fd, &st) == 0);
>  
>  	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
> -	CU_TEST(buf != MAP_FAILED);
> -
> +	if (buf == MAP_FAILED) {
> +		printf("[KERNEL DOES NOT ALLOW MMAP OF BTF FILE] ...");

Hmm. Instead of failing, let's instead allocate memory and read it, and
use that instead.

	char *btf_buf = NULL;
	[..]

	if (buf == MAP_FAILED) {
		btf_buf = malloc(st.size);
		/* error check here */
		CU_TEST(read(fd, btf_buf, st.st_size) == st.st_size);
	}
	[..]
	if (btf_buf)
		free(btf_buf);
	else
		munmap(btf, st.st_size); 

or something like that.

Thanks,

-- Steve




> +		close(fd);
> +		return;
> +	}
>  	CU_TEST(tep_load_btf(test_tep, buf, st.st_size) == 0);
>  
>  	munmap(buf, st.st_size);

