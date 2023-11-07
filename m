Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0765AE569;
	Tue,  7 Nov 2023 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNyTBRsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA885C433C7;
	Tue,  7 Nov 2023 09:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699349532;
	bh=2de/ujfjpG8mGlZWE7v/o1nNFaTyVAJBU4Ts5xFC4U0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LNyTBRsD05STGYMOgAp7X7/N0gA+x1NsiEoSS9iKpCh7a3mCWBTau6vGYnAjuUXfw
	 CJWgEeO9HFa7knJEmYnCEG30wnz+oNoIhDQKXlWq70W6BC/NyqxgajmtDgHzZ2Shle
	 Cjjpukmc2z9RJ6V3ngSJKpEI8DgRCk1zmPP7J9imVDfx1Ii6XeQmKNGFgKHSgqbfo+
	 qTM1Lv+gAGaNTmROZVigZlRoR6PnBbBpaIzgSPK6vq+uVLHudGOl58oyEhaJfH/WYp
	 am1yeP2MM2KY5omGv3KBPE+AJ346FMudJYcicBuxYh2EIGi/d24+PEEHkLi5ltuVXJ
	 T9U6eMbLNszNw==
Date: Tue, 7 Nov 2023 18:32:07 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa
 <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ian Rogers
 <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar
 <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-perf-users@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org,
 linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 33/48] perf dwarf-aux: Check allowed DWARF Ops
Message-Id: <20231107183207.2e3aded5985f699fdb3bcd16@kernel.org>
In-Reply-To: <20231012035111.676789-34-namhyung@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
	<20231012035111.676789-34-namhyung@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Oct 2023 20:50:56 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> The DWARF location expression can be fairly complex and it'd be hard
> to match it with the condition correctly.  So let's be conservative
> and only allow simple expressions.  For now it just checks the first
> operation in the list.  The following operations looks ok:
> 
>  * DW_OP_stack_value
>  * DW_OP_deref_size
>  * DW_OP_deref
>  * DW_OP_piece
> 
> To refuse complex (and unsupported) location expressions, add
> check_allowed_ops() to compare the rest of the list.  It seems earlier
> result contained those unsupported expressions.  For example, I found
> some local struct variable is placed like below.
> 
>  <2><43d1517>: Abbrev Number: 62 (DW_TAG_variable)
>     <43d1518>   DW_AT_location    : 15 byte block: 91 50 93 8 91 78 93 4 93 84 8 91 68 93 4
>         (DW_OP_fbreg: -48; DW_OP_piece: 8;
>          DW_OP_fbreg: -8; DW_OP_piece: 4;
>          DW_OP_piece: 1028;
>          DW_OP_fbreg: -24; DW_OP_piece: 4)
> 
> Another example is something like this.
> 
>     0057c8be ffffffffffffffff ffffffff812109f0 (base address)
>     0057c8ce ffffffff812112b5 ffffffff812112c8 (DW_OP_breg3 (rbx): 0;
>                                                 DW_OP_constu: 18446744073709551612;
>                                                 DW_OP_and;
>                                                 DW_OP_stack_value)
> 
> It should refuse them.  After the change, the stat shows:
> 
>   Annotate data type stats:
>   total 294, ok 158 (53.7%), bad 136 (46.3%)
>   -----------------------------------------------------------
>           30 : no_sym
>           32 : no_mem_ops
>           53 : no_var
>           14 : no_typeinfo
>            7 : bad_offset
> 

The code itself looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

If this fixes the previous patch in the same series (this seems a fix for the
main usecase), please make it to a single patch.

Thank you,

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/dwarf-aux.c | 44 +++++++++++++++++++++++++++++++++----
>  1 file changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index 7f3822d08ab7..093d7e82b333 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -1305,6 +1305,34 @@ static bool match_var_offset(Dwarf_Die *die_mem, struct find_var_data *data,
>  	return true;
>  }
>  
> +static bool check_allowed_ops(Dwarf_Op *ops, size_t nops)
> +{
> +	/* The first op is checked separately */
> +	ops++;
> +	nops--;
> +
> +	/*
> +	 * It needs to make sure if the location expression matches to the given
> +	 * register and offset exactly.  Thus it rejects any complex expressions
> +	 * and only allows a few of selected operators that doesn't change the
> +	 * location.
> +	 */
> +	while (nops) {
> +		switch (ops->atom) {
> +		case DW_OP_stack_value:
> +		case DW_OP_deref_size:
> +		case DW_OP_deref:
> +		case DW_OP_piece:
> +			break;
> +		default:
> +			return false;
> +		}
> +		ops++;
> +		nops--;
> +	}
> +	return true;
> +}
> +
>  /* Only checks direct child DIEs in the given scope. */
>  static int __die_find_var_reg_cb(Dwarf_Die *die_mem, void *arg)
>  {
> @@ -1332,25 +1360,31 @@ static int __die_find_var_reg_cb(Dwarf_Die *die_mem, void *arg)
>  		/* Local variables accessed using frame base register */
>  		if (data->is_fbreg && ops->atom == DW_OP_fbreg &&
>  		    data->offset >= (int)ops->number &&
> +		    check_allowed_ops(ops, nops) &&
>  		    match_var_offset(die_mem, data, data->offset, ops->number))
>  			return DIE_FIND_CB_END;
>  
>  		/* Only match with a simple case */
>  		if (data->reg < DWARF_OP_DIRECT_REGS) {
> -			if (ops->atom == (DW_OP_reg0 + data->reg) && nops == 1)
> +			/* pointer variables saved in a register 0 to 31 */
> +			if (ops->atom == (DW_OP_reg0 + data->reg) &&
> +			    check_allowed_ops(ops, nops))
>  				return DIE_FIND_CB_END;
>  
>  			/* Local variables accessed by a register + offset */
>  			if (ops->atom == (DW_OP_breg0 + data->reg) &&
> +			    check_allowed_ops(ops, nops) &&
>  			    match_var_offset(die_mem, data, data->offset, ops->number))
>  				return DIE_FIND_CB_END;
>  		} else {
> +			/* pointer variables saved in a register 32 or above */
>  			if (ops->atom == DW_OP_regx && ops->number == data->reg &&
> -			    nops == 1)
> +			    check_allowed_ops(ops, nops))
>  				return DIE_FIND_CB_END;
>  
>  			/* Local variables accessed by a register + offset */
>  			if (ops->atom == DW_OP_bregx && data->reg == ops->number &&
> +			    check_allowed_ops(ops, nops) &&
>  			    match_var_offset(die_mem, data, data->offset, ops->number2))
>  				return DIE_FIND_CB_END;
>  		}
> @@ -1412,7 +1446,8 @@ static int __die_find_var_addr_cb(Dwarf_Die *die_mem, void *arg)
>  		if (data->addr < ops->number)
>  			continue;
>  
> -		if (match_var_offset(die_mem, data, data->addr, ops->number))
> +		if (check_allowed_ops(ops, nops) &&
> +		    match_var_offset(die_mem, data, data->addr, ops->number))
>  			return DIE_FIND_CB_END;
>  	}
>  	return DIE_FIND_CB_SIBLING;
> @@ -1501,7 +1536,8 @@ int die_get_cfa(Dwarf *dwarf, u64 pc, int *preg, int *poffset)
>  		return -1;
>  
>  	if (!dwarf_cfi_addrframe(cfi, pc, &frame) &&
> -	    !dwarf_frame_cfa(frame, &ops, &nops) && nops == 1) {
> +	    !dwarf_frame_cfa(frame, &ops, &nops) &&
> +	    check_allowed_ops(ops, nops)) {
>  		*preg = reg_from_dwarf_op(ops);
>  		*poffset = offset_from_dwarf_op(ops);
>  		return 0;
> -- 
> 2.42.0.655.g421f12c284-goog
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
