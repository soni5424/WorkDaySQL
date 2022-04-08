select A.NoSO
from TrxSO A,
	TrxSOKirim B
where A.StatusInvoiced=1
	and A.NoSO=B.NoSO