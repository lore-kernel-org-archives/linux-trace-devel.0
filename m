Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76EF1AC885
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Sep 2024 16:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072713; cv=none; b=i6LzPE4fWnJQXwWN3Ry9KiCKZbTpFY+VopNBhEkA5GMAi2zsCG4JgbP0RF3GULq2gAd+eEDj2O79dnbxA0clnoZQwvEjuiYN9VzHlvilM5fd+Jx+Vl3XpJpgc47bDMCPL/S1Wsv4dFCPMxERUo4H3ti8REXVUEXopONhVk1jWrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072713; c=relaxed/simple;
	bh=2vS2XwYqLzeT7vx4yVSt5y+oImtLZXuFN0Zc0EKNd7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gnbzsqYHgLAMdXigxi+goYwKHTve1n/X9f5JG8vEhuqlIRrXcgWDMb/QkO7UQtti6Bq4FwtDm9LkGS2S1g6ZW4B1JLAVQKXwxsn041ttaX90zIcnnCoNCxDsIAhTnX36SgtnNoDWOn+mXlOZIj5pF80n4TuRiEtW/6T5iPPApJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0cxx0Z9k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=edW/spRL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0cxx0Z9k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=edW/spRL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0cxx0Z9k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="edW/spRL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0cxx0Z9k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="edW/spRL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC8471FD03;
	Wed, 11 Sep 2024 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1726072708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pc7lgf8EUGChVHWEyA+1oSVGuLozSzuWsfNFU3G2Ddo=;
	b=0cxx0Z9kHA1Ota/AB8hubbw9+Hc+vBU5yzkUDj55Z4spEIJD1wz9By7dPm6+iciI1lQvDj
	MDXDVuAmjHJkyO56kVJtx4VTnThgmPj80pmr0850af7asAkQLevI9XOEgulPh41Fc2nBbw
	4eaifCEAOvoawzdaowUUayW5IUhsK94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1726072708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pc7lgf8EUGChVHWEyA+1oSVGuLozSzuWsfNFU3G2Ddo=;
	b=edW/spRLMJLKCK66rOEM8D852lrLCGnZS9NkoUt3Gx0eVeJZqOQi9J8SO6ohW+XRx97rgW
	h1Yk1x6rZcqr+iCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1726072708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pc7lgf8EUGChVHWEyA+1oSVGuLozSzuWsfNFU3G2Ddo=;
	b=0cxx0Z9kHA1Ota/AB8hubbw9+Hc+vBU5yzkUDj55Z4spEIJD1wz9By7dPm6+iciI1lQvDj
	MDXDVuAmjHJkyO56kVJtx4VTnThgmPj80pmr0850af7asAkQLevI9XOEgulPh41Fc2nBbw
	4eaifCEAOvoawzdaowUUayW5IUhsK94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1726072708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pc7lgf8EUGChVHWEyA+1oSVGuLozSzuWsfNFU3G2Ddo=;
	b=edW/spRLMJLKCK66rOEM8D852lrLCGnZS9NkoUt3Gx0eVeJZqOQi9J8SO6ohW+XRx97rgW
	h1Yk1x6rZcqr+iCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C9753132CB;
	Wed, 11 Sep 2024 16:38:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WGQ2MITH4WZpBgAAD6G6ig
	(envelope-from <jjindrak@suse.cz>); Wed, 11 Sep 2024 16:38:28 +0000
From: jjindrak@suse.cz
To: linux-trace-devel@vger.kernel.org
Cc: jjindrak@suse.cz
Subject: [PATCH 1/2] trace-cmd lib: Fix potential integer overflow in tracecmd_write_cpu_data()
Date: Wed, 11 Sep 2024 18:36:52 +0200
Message-Id: <20240911163653.12606-2-jjindrak@suse.cz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20240911163653.12606-1-jjindrak@suse.cz>
References: <20240911163653.12606-1-jjindrak@suse.cz>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [0.20 / 50.00];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: 0.20
X-Spam-Flag: NO

From: Jaroslav Jindrak <jjindrak@suse.cz>

In out_write_cpu_data(), we stat() the cpu data files and store their
information in an instance of struct cpu_data_source, which has a size
field of type int. However, stat() stores the size of the file as off_t,
which means that the following check in tracecmd_write_cpu_data() will
not work with large enough files whose size fit in an off_t, but not in
an int

	ret = stat(cpu_data_files[i], &st);
	if (ret < 0) {
		tracecmd_warning("can not stat '%s'", cpu_data_files[i]);
		break;
	}
	...
	data[i].size = st.st_size;

due to the error being in the actual assignment to data[i].size. This
int value (potentially negative) gets later assigned to the file_size
field of struct data_file_write in out_write_cpu_data() and later
compared to the variable read_size, which can lead to the following
error:

 libtracecmd: Invalid argument
   did not match size of 3451486208 to -843481088

Signed-off-by: Jaroslav Jindrak <jjindrak@suse.cz>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index ebd6f152..a6b39344 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -93,7 +93,7 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 
 struct cpu_data_source {
 	int fd;
-	int size;
+	off_t size;
 	off_t offset;
 };
 
-- 
2.37.1

