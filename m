Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CE226FA5E
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Nov 2025 19:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763147352; cv=none; b=DFAQ+Pi8YPjAbfwcHf/yyi0OSALtKX3xA+zzZB6FuzhW0+pHam2GKtY/XXfJp9Pqezq6DcJ2E4N7KpFzO7h0xmKAhkM/aF8mNEJ9Y7RdcqM3gDvwIOEn7ys1X96lMB9QQ2NPWu2ArO06NYKmFdKuUm5+37+8fA+1E0JoRvw9Uro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763147352; c=relaxed/simple;
	bh=C0KT18Y9jQoXyv39LiwOaZ46qvLG7+JrY+gY5S8LQ0M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=OcA8jGGjk12JuX6XYO6zaVXudf4ZcnCoYnn+79gFKfV5VhxOUDPKeP9zp2C0sEG7Vnwx2iieiq+29rvD03i8SaOMSgW8CRonL1UQt8jTnyPqRvUUljEBftq4O7BPbD27fhwjN7mceeThbfcqjd7gYb8Md7dOBwiWBVQXrVHEhvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 348944C482;
	Fri, 14 Nov 2025 19:09:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id BF4256000A;
	Fri, 14 Nov 2025 19:09:07 +0000 (UTC)
Date: Fri, 14 Nov 2025 14:09:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Douglas Raillard <douglas.raillard@arm.com>
Subject: [PATCH] libtraceevent: Use BTF_INT_BITS/OFFSET() when parsing int
 parameters
Message-ID: <20251114140925.3df4f3ff@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ohxfjjxfeoezu73peqo3kzcd87d6zrf4
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: BF4256000A
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/vEaUSy9l8iY1mDL2uD0XMXvuXg439q3E=
X-HE-Tag: 1763147347-270273
X-HE-Meta: U2FsdGVkX19Jn97S4klgrAIuzAQ17NRn/PWJYoQ64Zu6toqCDI2qx1MgqY96kNPetM0QRkdM7ekZJGN5iaF23B6XgRjzwkehHOnBUWK50zcHUtRZjFTUWNh5QpgLoid/8zr93ykRgROy3m0S97ZT3+6ACR206cQ9AUt4MI5Hdj6ETB376AuAi6mhd6VTom3OTfJOQTMwuUEJeGFevO3B0rL+eW0xTRXqBjjlGXVlu4rokN+UyLFwcoIoQ8bUBjL+GltPxmHulktBJthJAg8R/PqfsP3IpQgdHVpExewMJ9tRiJjy3CRjLAJeeKnkULrRSwnao5eECkZ/B6OvoCszBc3IoRNnAhen60yyDG6r5gmWpo7wpnqIbGtTpyaFy7cuMM6Yn/qzCD7R3sXhVNx+Cyht8gARQ//lo2qvfT29xoHJ3t13wzobMUkSjwXzXNXVx6hBJu9BvNEdtaJ0bTNgOg==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The BTF_KIND_INT can be less than 64 bits in size and the
BTF_INT_BITS(encode) will express that.

Also process BTF_INT_OFFSET() even though it is likely to be zero every
time, but it follows the specification.

Link: https://lore.kernel.org/all/82376535-30a5-4602-aac7-1bd3abcd271a@arm.com/

Suggested-by: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/trace-btf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index 742cffd35edc..d0231b49d144 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -413,6 +413,8 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 
 	for (a = 0, p = 0; p < nr; a++, p++) {
 		struct btf_type *t;
+		int offset;
+		int bits;
 
 		if (p)
 			trace_seq_puts(s, ", ");
@@ -440,6 +442,11 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 			break;
 		case BTF_KIND_INT:
 			encode = *(int *)((void *)t + sizeof(*t));
+			bits = BTF_INT_BITS(encode);
+			offset = BTF_INT_OFFSET(encode);
+			arg >>= offset;
+			if (bits < 64)
+				arg &= (1ULL << bits) - 1;
 			/* Print unsigned ints as hex */
 			if (BTF_INT_ENCODING(encode) & BTF_INT_SIGNED)
 				trace_seq_printf(s, "%lld", arg);
-- 
2.51.0

