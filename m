Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4BE2FE578
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 23:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770075342; cv=none; b=I5MLwTnlO6TsIhfv8VTLaRAtsown0DY5nWz+A6NnnZWGLeAxv97MOIIG60E3nyEpPNK3vM7gOUIkaRk2Vhr6OBhXZpQdJ8KCEQz74qmFMlUa30pDtdnt0xX7tuZ75oAFZS1Z4I+lVJssmVvxBMmdVKGP8eA0OHgWE7WVB9jNHXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770075342; c=relaxed/simple;
	bh=OE0fBLR0FuxV8tXB3lMoLDgjLjwfk44Yf1qW/5XO5p0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OsHCpnFM0KOJw5tXRtVVVbrpbRb2W8DtnASGpzPatIBjVSndnvLVPgIVPhuEHfAzux7b+wcJcurSr0v6IVPyiPFdzXhmvJVD1L5pBbe0k2bZ56ey3MjW1k2iTwWBLxNy5S7RGWlyi0Q/wRPw+N2+vMN+TxYUg072+HxBwZs6G04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE27F13A83F;
	Mon,  2 Feb 2026 23:35:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id ED80E20027;
	Mon,  2 Feb 2026 23:35:37 +0000 (UTC)
Date: Mon, 2 Feb 2026 18:36:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>
Subject: Re: [PATCH v3 4/6] trace-cmd record / report: Record BTF file if
 function arguments are recorded
Message-ID: <20260202183603.157d8117@gandalf.local.home>
In-Reply-To: <20260202223941.2031858-5-rostedt@goodmis.org>
References: <20260202223941.2031858-1-rostedt@goodmis.org>
	<20260202223941.2031858-5-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ED80E20027
X-Stat-Signature: aosssowkoiren16dd8p6tqjoaoqfz8pq
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19ov1DmB36uR8jIHCklb9EsFjvvqHKnuN0=
X-HE-Tag: 1770075337-714027
X-HE-Meta: U2FsdGVkX1+PWJrow4tdMsh5sbSwvxhnVQGegRnHjFOhZmUVNe7ADIfapYs0c1cMossTeLOMMASzCrZvEDmE5wJqcxhdAN6a8cOkRKT1JK6KJRMiRkF7QXPaHI8pEsUiRG94/ATVl63X/fcvz6BvODfZMj4Q8B4Ry0Gg4Dnh5GKwuSzuymcrVSLXsWonCYkpmjZEKJfVXUlZtGTbBJJ5SO7rEgWV1AJ2Fuke0yaWgYtfkSXL3Vs6Gf4X07m7XiQMysTpN9BOUu0dRTeSeIEmE9UziYGoUsCKx1jrpIv+c/nhXydcQ2vIZiJCib7uXaz2EbGIAakd27H+fmmegre7js3DWwAM5GbxNrsyIrrSeXOPq+TjXFCwRUxK2yFFH+eC

On Mon,  2 Feb 2026 17:36:59 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +#define BTF_FILE "/sys/kernel/btf/vmlinux"
> +
> +int tracecmd_append_btf_file(struct tracecmd_output *handle)
> +{
> +	tsize_t offset, size, check_size;
> +	struct tracecmd_option *option;
> +	struct iovec *vect;
> +	struct stat st;
> +	int ret;
> +
> +	if (!HAS_SECTIONS(handle))
> +		return -1;
> +
> +	ret = stat(BTF_FILE, &st);
> +	if (ret < 0)
> +		return -1;
> +
> +	offset = write_compress_section_header(handle, TRACECMD_OPTION_BTF_FILE, NULL, true);
> +	if (offset == (off_t)-1)
> +		return -1;
> +
> +	tcmd_out_compression_start(handle);
> +
> +	check_size = copy_file(handle, BTF_FILE);
> +	if (st.st_size != check_size) {
> +		errno = EINVAL;
> +		tracecmd_warning("error in size of file '%s'", BTF_FILE);
> +		return -1;
> +	}
> +
> +	if (tcmd_out_compression_end(handle))
> +		return -1;
> +
> +	if (tcmd_out_update_section_header(handle, offset))
> +		return -1;
> +
> +	return 0;

Bah, the below was from some old versions. I keep forgetting to remove it.

Will be sending a v4 shortly.

-- Steve


> +
> +	/*
> +	 * BTF file
> +	 *  - data offset in the file
> +	 *  - data size
> +	 */
> +
> +	vect = calloc(2, sizeof(struct iovec));
> +	if (!vect)
> +		return -1;
> +	vect[0].iov_base = &offset;
> +	vect[0].iov_len = 8;
> +	vect[1].iov_base = &size;
> +	vect[1].iov_len = 8;
> +
> +	option = tracecmd_add_option_v(handle, TRACECMD_OPTION_BTF_FILE, vect, 2);
> +	free(vect);
> +
> +	if (!option)
> +		return -1;
> +
> +	if (do_lseek(handle, 0, SEEK_END) == (off_t)-1)
> +		return -1;
> +
> +	return 0;
> +}
> +
